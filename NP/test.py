
import sys
import math

import torch
import torch.nn as nn
import torch.nn.functional as F
import numpy as np
import nltk
nltk.download('punkt')
from typing import List, Tuple, Dict, Set, Union

def pad_sents(sents, pad_token):
    sents_padded = []

    max_len=0
    for sent in sents:
        max_len = max(list(map(len, sent)) + [max_len])
    for sent in sents:
        sents_padded.append([w + (pad_token * (max_len - len(w))) for w in sent])


    return sents_padded

class ModelEmbeddings(nn.Module):
    def __init__(self, embed_size, vocab):
        super(ModelEmbeddings, self).__init__()
        self.embed_size = embed_size

        # default values
        self.source = None
        self.target = None

        src_pad_token_idx = vocab.src['<pad>']
        tgt_pad_token_idx = vocab.tgt['<pad>']
        self.source = nn.Embedding(num_embeddings=len(vocab.src), embedding_dim=embed_size, padding_idx=src_pad_token_idx)
        self.target = nn.Embedding(num_embeddings=len(vocab.tgt), embedding_dim=embed_size, padding_idx=tgt_pad_token_idx)

class NMT(nn.Module):
    def __init__(self, embed_size, hidden_size, vocab, dropout_rate=0.2):

        super(NMT, self).__init__()
        self.model_embeddings = ModelEmbeddings(embed_size, vocab)
        self.hidden_size = hidden_size
        self.dropout_rate = dropout_rate
        self.vocab = vocab

        # default values
        self.encoder = None
        self.decoder = None
        self.h_projection = None
        self.c_projection = None
        self.att_projection = None
        self.combined_output_projection = None
        self.target_vocab_projection = None
        self.dropout = None
        # For sanity check only, not relevant to implementation
        self.gen_sanity_check = False
        self.counter = 0

        self.encoder = nn.LSTM(input_size=embed_size, hidden_size=hidden_size, bidirectional=True, bias=True)
        self.decoder = nn.LSTMCell(input_size=embed_size, hidden_size=hidden_size, bias=True)
        self.h_projection = nn.Linear(2 * hidden_size, hidden_size, bias=False)
        self.c_projection = nn.Linear(2 * hidden_size, hidden_size, bias=False)
        self.att_projection = nn.Linear(2 * hidden_size, hidden_size, bias=False)
        self.combined_output_projection = nn.Linear(3 * hidden_size, hidden_size, bias=False)
        self.target_vocab_projection = nn.Linear(hidden_size, len(vocab.tgt), bias=False)
        self.dropout = nn.Dropout(p=dropout_rate)


    def forward(self, source: List[List[str]], target: List[List[str]]) -> torch.Tensor:
        """ Take a mini-batch of source and target sentences, compute the log-likelihood of
        target sentences under the language models learned by the NMT system.

        @param source (List[List[str]]): list of source sentence tokens
        @param target (List[List[str]]): list of target sentence tokens, wrapped by `<s>` and `</s>`

        @returns scores (Tensor): a variable/tensor of shape (b, ) representing the
                                    log-likelihood of generating the gold-standard target sentence for
                                    each example in the input batch. Here b = batch size.
        """
        # Compute sentence lengths
        source_lengths = [len(s) for s in source]

        # Convert list of lists into tensors
        source_padded = self.vocab.src.to_input_tensor(source, device=self.device)   # Tensor: (src_len, b)
        target_padded = self.vocab.tgt.to_input_tensor(target, device=self.device)   # Tensor: (tgt_len, b)

        ###     Run the network forward:
        ###     1. Apply the encoder to `source_padded` by calling `encode()`
        ###     2. Generate sentence masks for `source_padded` by calling `generate_sent_masks()`
        ###     3. Apply the decoder to compute combined-output by calling `decode()`
        ###     4. Compute log probability distribution over the target vocabulary using the
        ###        combined_outputs returned by the `decode()` function.

        enc_hiddens, dec_init_state = encode(self, source_padded, source_lengths) # Implemented in Question 1.3
        enc_masks = self.generate_sent_masks(enc_hiddens, source_lengths)
        combined_outputs = decode(self, enc_hiddens, enc_masks, dec_init_state, target_padded)
        P = F.log_softmax(self.target_vocab_projection(combined_outputs), dim=-1)

        # Zero out, probabilities for which we have nothing in the target text
        target_masks = (target_padded != self.vocab.tgt['<pad>']).float()

        # Compute log probability of generating true target words
        target_gold_words_log_prob = torch.gather(P, index=target_padded[1:].unsqueeze(-1), dim=-1).squeeze(-1) * target_masks[1:]
        scores = target_gold_words_log_prob.sum(dim=0)
        return scores

    def generate_sent_masks(self, enc_hiddens: torch.Tensor, source_lengths: List[int]) -> torch.Tensor:
        """ Generate sentence masks for encoder hidden states.

        @param enc_hiddens (Tensor): encodings of shape (b, src_len, 2*h), where b = batch size,
                                      src_len = max source length, h = hidden size.
        @param source_lengths (List[int]): List of actual lengths for each of the sentences in the batch.

        @returns enc_masks (Tensor): Tensor of sentence masks of shape (b, src_len),
                                    where src_len = max source length, h = hidden size.
        """
        enc_masks = torch.zeros(enc_hiddens.size(0), enc_hiddens.size(1), dtype=torch.float)
        for e_id, src_len in enumerate(source_lengths):
            enc_masks[e_id, src_len:] = 1
        return enc_masks.to(self.device)

    @property
    def device(self) -> torch.device:
        """ Determine which device to place the Tensors upon, CPU or GPU.
        """
        return self.model_embeddings.source.weight.device

    @staticmethod
    def load(model_path: str):
        """ Load the model from a file.
        @param model_path (str): path to model
        """
        params = torch.load(model_path, map_location=lambda storage, loc: storage)
        args = params['args']
        model = NMT(vocab=params['vocab'], **args)
        model.load_state_dict(params['state_dict'])

        return model

    def save(self, path: str):
        """ Save the odel to a file.
        @param path (str): path to the model
        """
        print('save model parameters to [%s]' % path, file=sys.stderr)

        params = {
            'args': dict(embed_size=self.model_embeddings.embed_size, hidden_size=self.hidden_size, dropout_rate=self.dropout_rate),
            'vocab': self.vocab,
            'state_dict': self.state_dict()
        }

        torch.save(params, path)

from torch.nn.utils.rnn import pad_packed_sequence, pack_padded_sequence

def encode(model, source_padded: torch.Tensor, source_lengths: List[int]) -> Tuple[torch.Tensor, Tuple[torch.Tensor, torch.Tensor]]:
    """ Apply the encoder to source sentences to obtain encoder hidden states.
        Additionally, take the final states of the encoder and project them to obtain initial states for decoder.

    @param model (NMT): nn.Module you have implemented in question 1.3
    @param source_padded (Tensor): Tensor of padded source sentences with shape (src_len, b), where
                                    b = batch_size, src_len = maximum source sentence length. Note that
                                    these have already been sorted in order of longest to shortest sentence.
    @param source_lengths (List[int]): List of actual lengths for each of the source sentences in the batch
    @returns enc_hiddens (Tensor): Tensor of hidden units with shape (b, src_len, h*2), where
                                    b = batch size, src_len = maximum source sentence length, h = hidden size.
    @returns dec_init_state (tuple(Tensor, Tensor)): Tuple of tensors representing the decoder's initial
                                            hidden state and cell.
    """
    enc_hiddens, dec_init_state = None, None

    ### YOUR CODE HERE (~ 8 Lines)
    ### TODO:
    ###     1. Construct Tensor `X` of source sentences with shape (src_len, b, e) using the source model embeddings.
    ###         src_len = maximum source sentence length, b = batch size, e = embedding size. Note
    ###         that there is no initial hidden state or cell for the decoder.
    ###     2. Compute `enc_hiddens`, `last_hidden`, `last_cell` by applying the encoder to `X`.
    ###         - Before you can apply the encoder, you need to apply the `pack_padded_sequence` function to X.
    ###         - After you apply the encoder, you need to apply the `pad_packed_sequence` function to enc_hiddens.
    ###         - Note that the shape of the tensor returned by the encoder is (src_len, b, h*2) and we want to
    ###           return a tensor of shape (b, src_len, h*2) as `enc_hiddens`.
    ###     3. Compute `dec_init_state` = (init_decoder_hidden, init_decoder_cell):
    ###         - `init_decoder_hidden`:
    ###             `last_hidden` is a tensor shape (2, b, h). The first dimension corresponds to forwards and backwards.
    ###             Concatenate the forwards and backwards tensors to obtain a tensor shape (b, 2*h).
    ###             Apply the h_projection layer to this in order to compute init_decoder_hidden.
    ###             This is h_0^{dec} in the equations. Here b = batch size, h = hidden size
    ###         - `init_decoder_cell`:
    ###             `last_cell` is a tensor shape (2, b, h). The first dimension corresponds to forwards and backwards.
    ###             Concatenate the forwards and backwards tensors to obtain a tensor shape (b, 2*h).
    ###             Apply the c_projection layer to this in order to compute init_decoder_cell.
    ###             This is c_0^{dec} in the equations. Here b = batch size, h = hidden size


    ### See the following docs, as you may need to use some of the following functions in your implementation:
    ###     Pack the padded sequence X before passing to the encoder:
    ###         https://pytorch.org/docs/stable/nn.html#torch.nn.utils.rnn.pack_padded_sequence
    ###     Pad the packed sequence, enc_hiddens, returned by the encoder:
    ###         https://pytorch.org/docs/stable/nn.html#torch.nn.utils.rnn.pad_packed_sequence
    ###     Tensor Concatenation:
    ###         https://pytorch.org/docs/stable/torch.html#torch.cat
    ###     Tensor Permute:
    ###         https://pytorch.org/docs/stable/tensors.html#torch.Tensor.permute


    ### END YOUR CODE

    return enc_hiddens, dec_init_state