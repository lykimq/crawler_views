let caller = Sys.argv.(0)
let version = "dev"

let arg_offset =
  let open Cmdliner in
  let default = 0 in
  let arg =
    Arg.info
      [ "offset"; "o" ]
      ~docv:"NUM"
      ~doc:"Specifies which or how many items should be skipped"
  in
  Arg.(value (opt int default arg))
;;

let arg_limit =
  let open Cmdliner in
  let default = 100 in
  let arg =
    Arg.info
      [ "limit"; "l" ]
      ~docv:"NUM"
      ~doc:"Maximum number of items to return"
  in
  Arg.(value (opt int default arg))
;;

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

let action_addresses =
  let open Cmdliner in
  let doc =
    "Retreive the list of smart-contract's address included between a range"
  in
  let exits = Cmd.Exit.defaults in
  let info = Cmd.info "addresses" ~doc ~exits in
  let callback network offset limit =
    let open Lwt.Syntax in
    let+ contracts = Lib.Client.Contract.get ~network ~offset ~limit () in
    let () =
      List.iteri
        (fun i Lib.Client.Contract.{ id; address } ->
          Format.printf "%d\tid:%d\taddress: %s\n" i id address)
        contracts
    in
    `Ok ()
  in
  let term =
    let open Term in
    ret
      (const (fun network offset limit ->
         Lwt_main.run @@ callback network offset limit)
      $ Lib.Network.arg
      $ arg_offset
      $ arg_limit)
  in
  Cmd.v info term
;;

let action_compute =
  let open Cmdliner in
  let doc = "Compute the number of views for each contracts" in
  let exits = Cmd.Exit.defaults in
  let info = Cmd.info "compute" ~doc ~exits in
  let callback network offset =
    let open Lwt.Syntax in
    let filename = Lib.Network.compute_filename network in
    let* fd = Lwt_unix.openfile filename [ O_WRONLY; O_TRUNC; O_CREAT ] 0o777 in
    let channel = Lwt_io.of_fd ~mode:Output fd in
    let* _ = Lib.Client.Contract.compute ~network ~offset channel in
    let+ () = Lwt_unix.close fd in
    `Ok ()
  in
  let term =
    let open Term in
    ret
      (const (fun network offset -> Lwt_main.run @@ callback network offset)
      $ Lib.Network.arg
      $ arg_offset)
  in
  Cmd.v info term
;;

let actions = [ action_count; action_addresses; action_compute ]

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
