.PHONY: all build clean lint check-lint utop deps dev-deps

all: build

build:
	dune build

clean:
	dune clean

utop:
	dune utop

deps:
	opam install . --locked --deps-only --with-doc --with-test -y

dev-deps:
	opam install dune merlin ocamlformat ocp-indent utop -y

lint:
	dune build @fmt --auto-promote

check-lint:
	dune build @fmt
