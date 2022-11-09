(** A simple HTTP client based on COHTTP. *)

(** [Client.get ~headers url action] will perfom [action] with the response and
    the body of the GET request on the given url. *)
val get
  :  ?headers:(string * string) list
  -> Api.t
  -> (Cohttp.Response.t -> Cohttp_lwt.Body.t -> 'a Lwt.t)
  -> 'a Lwt.t

module Contract : sig
  (** Returns the number of smart-contracts originated on a given network. *)
  val count : ?network:Network.t -> unit -> int Lwt.t
end
