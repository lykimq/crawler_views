type t = string

let base_url ?network () =
  let fragment =
    Option.fold
      ~none:""
      ~some:(fun x -> "." ^ Network.to_uri_fragment x)
      network
  in
  "https://api" ^ fragment ^ ".tzkt.io/v1/"
;;

let to_string x = x

module Contract = struct
  let base_url ?network () =
    let base = base_url ?network () in
    base ^ "contracts/"
  ;;

  let count ?network () =
    let base = base_url ?network () in
    base ^ "count"
  ;;

  let get ?network ~offset ~limit () =
    let base = base_url ?network () in
    base ^ Format.asprintf "?offset=%d&limit=%d" offset limit
  ;;

  let views ?network ~address () =
    let base = base_url ?network () in
    base ^ address ^ "/views"
  ;;
end
