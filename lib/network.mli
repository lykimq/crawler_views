(** Describes the different network of Tezos. *)

type t =
  | Kathmandu
  | Ghost
  | Jakarta
  | Main

val to_string : t -> string
val from_string : string -> t option
val to_uri_fragment : t -> string
val arg : t Cmdliner.Term.t
val compute_filename : t -> string
