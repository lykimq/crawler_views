# crawler_views

Collect statistics about [Tezos](https://tezos.com) views.

## Initialize environment

```shellsession
opam update
opam switch create . ocaml-base-compiler.4.14.0 --deps-only -y
eval $(opam env)
```

When the local switch build procedure is complete you can simply run the
following two commands to retrieve the project dependencies and to retrieve the
development dependencies (the second one is optional):

```shellsession
make deps
make dev-deps
```

## Usage

```shellsession
dune exec src/crawler_views.exe -- count
```

Will print on `stdout` the number of originated smart-contracts. You can add the
parameter `--network=(main|ghost|kathmandu|jakarta)` for specifiying a network.
(By default, `main` is given).
