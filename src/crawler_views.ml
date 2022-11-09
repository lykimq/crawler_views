let caller = Sys.argv.(0)
let version = "dev"

let action_count =
  let open Cmdliner in
  let doc =
    "Print on stdout the number of originated contract for the given network"
  in
  let exits = Cmd.Exit.defaults in
  let info = Cmd.info "count" ~doc ~exits in
  let callback network =
    let open Lwt.Syntax in
    let+ number_of_contracts = Lib.Client.Contract.count ~network () in
    let () = print_int number_of_contracts in
    `Ok ()
  in
  let term =
    let open Term in
    ret
      (const (fun network -> Lwt_main.run @@ callback network) $ Lib.Network.arg)
  in
  Cmd.v info term
;;

let actions = [ action_count ]

let main =
  let open Cmdliner in
  let doc = "Crawler views" in
  let sdocs = Manpage.s_common_options in
  let exits = Cmd.Exit.defaults in
  let info = Cmd.info caller ~version ~doc ~sdocs ~exits in
  let default_action = Term.(ret (const (`Help (`Pager, None)))) in
  Cmd.group info ~default:default_action actions
;;

let () = exit @@ Cmdliner.Cmd.eval main
