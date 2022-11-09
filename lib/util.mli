(** Some helpers. *)

val steps : total:int -> ?offset:int -> limit:int -> unit -> (int * int) list
