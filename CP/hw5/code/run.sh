#!/bin/bash

ASTFILENAME=target

python3 frontend/ast2json.py ./test/$1_buggy.py > /tmp/$ASTFILENAME.json
dune build
./_build/default/main.exe /tmp/$ASTFILENAME.json
#./_build/default/main.exe /tmp/$ASTFILENAME.json > _build/output.py
# python3.10 frontend/reformat.py _build/output.py > _build/formatted.py 
