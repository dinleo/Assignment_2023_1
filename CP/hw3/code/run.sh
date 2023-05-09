#!/bin/bash

ASTFILENAME=target

python3 frontend/ast2json.py test/$1.py > /tmp/$ASTFILENAME.json
dune build main.exe
./_build/default/main.exe /tmp/$ASTFILENAME.json
./_build/default/main.exe /tmp/$ASTFILENAME.json > _build/output.py
python3 frontend/reformat.py _build/output.py > _build/formatted.py
