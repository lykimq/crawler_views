(lang dune 3.0)
(name crawler_views)
(version dev)
(generate_opam_files true)

(source (github lykimq/crawler_views))
(license MIT)
(authors "Marigold <contact@marigold.dev>")
(maintainers "Marigold <contact@marigold.dev>")

(package
  (name crawler_views)
  (synopsis "A tool for crawling views statistics from tezos")
  (description "Crawling smart-contracts from Tezos Blockchain")
  (depends
    (dune (>= 3.0.0))
    (ocaml (>= 4.14.0))
    (preface (>= 1.0.0))
    (cmdliner (>= "1.1.1"))
    (lwt (>= "5.3.0"))
    (yojson (>= "1.7.0"))
    (ppx_yojson_conv (>= "0.14.0"))
    (tls (>= "0.15.4"))
    (cohttp-lwt-unix (>= "5.0.0"))))
