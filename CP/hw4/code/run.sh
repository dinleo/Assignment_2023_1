#!/bin/bash

ASTFILENAME=target

python3.11 frontend/ast2json.py test/$1.py > /tmp/$ASTFILENAME.json
dune build main.exe
./_build/default/main.exe /tmp/$ASTFILENAME.json
#./_build/default/main.exe /tmp/$ASTFILENAME.json > _build/$1.py
#python3.10 frontend/reformat.py _build/output.py > _build/formatted.py
