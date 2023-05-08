a = [['asd','asdv'], ['as','a'],['asdasf']]
def pad_sents(sents, pad_token):
    """ Pad list of sentences according to the longest sentence in the batch.
        The paddings should be at the end of each sentence.
    @param sents (list[list[str]]): list of sentences, where each sentence
                                    is represented as a list of words
    @param pad_token (str): padding token
    @returns sents_padded (list[list[str]]): list of sentences where sentences shorter
        than the max length sentence are padded out with the pad_token, such that
        each sentences in the batch now has equal length.
    """
    sents_padded = []
    ### YOUR CODE HERE (~6 Lines)
    max_len=0
    for sent in sents:
        max_len = max(list(map(len, sent)) + [max_len])
    for sent in sents:
        sents_padded.append([w + (pad_token * (max_len - len(w))) for w in sent])
    ### END YOUR CODE

    return sents_padded

print(pad_sents(a, '$'))