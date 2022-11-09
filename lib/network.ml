type t =
  | Kathmandu
  | Ghost
  | Jakarta
  | Main

let to_string = function
  | Kathmandu -> "kathmandu"
  | Ghost -> "ghost"
  | Jakarta -> "jakarta"
  | Main -> "main"
;;

let from_string value =
  match String.(trim @@ lowercase_ascii value) with
  | "kathmandu" -> Some Kathmandu
  | "ghost" -> Some Ghost
  | "jakarta" -> Some Jakarta
  | "main" -> Some Main
  | _ -> None
;;

let to_uri_fragment network = to_string network ^ "net"

let arg =
  let open Cmdliner in
  let doc = "The desired network" in
  let n_conv =
    let docv = doc in
    let printer ppf value = Format.fprintf ppf "%s" (to_string value) in
    let parser value =
      Option.to_result
        ~none:(`Msg (Format.asprintf "[%s] is an invalid network" value))
        (from_string value)
    in
    Arg.conv ~docv (parser, printer)
  in
  let arg = Arg.info ~doc ~docs:Manpage.s_common_options [ "network" ] in
  Arg.(required & opt (some n_conv) (Some Main) & arg)
;;
