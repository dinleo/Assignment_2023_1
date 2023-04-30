#!/bin/bash

ASTFILENAME=t7

python3.10 frontend/ast2json.py test/$ASTFILENAME.py > /tmp/$ASTFILENAME.json
dune build
./_build/default/main.exe /tmp/$ASTFILENAME.json
#./_build/default/main.exe /tmp/$ASTFILENAME.json > _build/output.py
# python3.10 frontend/reformat.py _build/output.py > _build/formatted.py 
