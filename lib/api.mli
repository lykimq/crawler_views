(** Describe the API endpoint of TzKit *)

(** Define an API entrypoint. *)
type t

(** Converts an API endpoint to a string. *)
val to_string : t -> string

(** [Api.base_url ?network ()] returns the base url of the TzKt API. It can be
    prefixed by a given network (see {:Network} for more precision.) *)
val base_url : ?network:Network.t -> unit -> t

module Contract : sig
  (** Entrypoints related to contract. *)

  (** [Api.Contract.base_url ?network ()] returns the base url of the TzKt API
      related to contracts. *)
  val base_url : ?network:Network.t -> unit -> t

  (** [Api.Contract.count ?network ()] returns the entry point that count the
      number of originated smart contracts originated in a given network. *)
  val count : ?network:Network.t -> unit -> t
end
