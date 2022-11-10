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

```shellsession
dune exec src/crawler_views.exe -- addresses --offset=NUM --limit=NUM
```

Will print on `stdout` the addresses of smart-contracts originated between
`offset` and `offset + limit`. (As for `count`, you can specify the network).

```shellsession
dune exec src/crawler_views.exe -- compute
```

Will produce a file `network.csv` (the name depends on the given network)
containing all addresses that holds views using this scheme:
`address;number_of_views`. (As for `count`, you can specify the network). You
can also add the flag `--offset=NUM` in order to start to a specific offset. For
`Mainnet`, it is recommanded to start with offset `67100` (because there is no
views before).
