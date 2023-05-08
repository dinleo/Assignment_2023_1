# Setup OCAML Dependencies
echo "[NOTE] Start Setup OCAML Dependencies"
eval $(opam env)
for pkg in "batteries 3.5.1" "core 0.15.0" "dune 3.5.0" "menhir 20200624" "zarith 1.10" "logs 0.7.0" "mtime 1.2.0" "yojson 2.0.2"; do
  pkg_pair=( $pkg )
  pkg_name=${pkg_pair[0]}
  pkg_version=${pkg_pair[1]}
  opam install -y -j $CORES "$pkg_name>=$pkg_version" >/dev/null 2>&1
  echo "[NOTE] $pkg_name: Installed as OCAML package"
done
echo "[NOTE] End-up Setup OCAML Dependencies"