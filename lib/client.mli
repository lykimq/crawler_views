(** A simple HTTP client based on COHTTP. *)

(** [Client.get ~headers url action] will perfom [action] with the response and
    the body of the GET request on the given url. *)
val get
  :  ?headers:(string * string) list
  -> Api.t
  -> (Cohttp.Response.t -> Cohttp_lwt.Body.t -> 'a Lwt.t)
  -> 'a Lwt.t

module Contract : sig
  type t = private
    { id : int
    ; address : string
    }

  type contracts = t list

  (** Returns the number of smart-contracts originated on a given network. *)
  val count : ?network:Network.t -> unit -> int Lwt.t

  (** Returns the contracts address and id on a given range for a given network. *)
  val get
    :  ?network:Network.t
    -> offset:int
    -> limit:int
    -> unit
    -> contracts Lwt.t

  val compute
    :  ?network:Network.t
    -> offset:int
    -> Lwt_io.output_channel
    -> Lwt_io.output_channel Lwt.t
end
