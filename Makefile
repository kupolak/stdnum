#
# This Makefile is not called from Opam but only used for
# convenience during development
#

DUNE 	= dune

.PHONY: all install test clean uninstall format install-ocamlformat doc doc-serve

all:
	$(DUNE) build

install: all
	$(DUNE) install stdnum

uninstall:
	$(DUNE) uninstall

test:
	$(DUNE) runtest

deps:
	opam install . --deps-only

clean:
	$(DUNE) clean

utop:
	$(DUNE) utop

doc:
	$(DUNE) build @doc

doc-serve: doc
	@echo "Starting documentation server at http://localhost:8080"
	@echo "Press Ctrl+C to stop"
	cd _build/default/_doc/_html && python3 -m http.server 8080

format:
	$(DUNE) build --auto-promote @fmt
	opam lint --normalise stdnum.opam > stdnum.tmp && mv stdnum.tmp stdnum.opam

install-ocamlformat:
	opam install -y ocamlformat=0.26.1