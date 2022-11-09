open Cohttp
module U = Cohttp_lwt_unix

let get ?(headers = []) url callback =
  let open Lwt.Syntax in
  let headers = Header.of_list headers in
  let uri = Uri.of_string (Api.to_string url) in
  let* response, body = U.Client.get ~headers uri in
  callback response body
;;

module View = struct
  type t = { name : string } [@@deriving yojson] [@@yojson.allow_extra_fields]
  type views = t list [@@deriving yojson]

  let get_for_contract ?network ~address () =
    let url = Api.Contract.views ?network ~address () in
    get url (fun _response body ->
      let open Lwt.Syntax in
      let+ body = Cohttp_lwt.Body.to_string body in
      body |> Yojson.Safe.from_string |> views_of_yojson)
  ;;
end

module Contract = struct
  type t =
    { id : int
    ; address : string
    }
  [@@deriving yojson] [@@yojson.allow_extra_fields]

  type contracts = t list [@@deriving yojson]

  let count ?network () =
    let url = Api.Contract.count ?network () in
    get url (fun _response body ->
      let open Lwt.Syntax in
      let+ body = Cohttp_lwt.Body.to_string body in
      int_of_string body)
  ;;

  let get ?network ~offset ~limit () =
    let url = Api.Contract.get ?network ~offset ~limit () in
    get url (fun _response body ->
      let open Lwt.Syntax in
      let+ body = Cohttp_lwt.Body.to_string body in
      body |> Yojson.Safe.from_string |> contracts_of_yojson)
  ;;

  let collect_views ?network channel =
    let rec aux channel = function
      | [] -> Lwt.return channel
      | { address; id } :: xs ->
        let open Lwt.Syntax in
        let* views = View.get_for_contract ?network ~address () in
        let len = List.length views in
        let* () =
          if len > 0
          then (
            let line = Format.asprintf "%d;%s;%d" id address len in
            let* () = Lwt_io.print line in
            Lwt_io.write_line channel line)
          else Lwt.return ()
        in
        aux channel xs
    in
    aux channel
  ;;

  let collect_contracts ?network channel =
    let rec aux channel = function
      | [] -> Lwt.return channel
      | (offset, limit) :: xs ->
        let open Lwt.Syntax in
        let* () = Lwt_io.printf "processing offset %d\n" offset in
        let* contracts = get ?network ~offset ~limit () in
        let* channel = collect_views ?network channel contracts in
        aux channel xs
    in
    aux channel
  ;;

  let compute ?network channel =
    let open Lwt.Syntax in
    let* total = count ?network () in
    let steps = Util.steps ~total ~limit:100 () in
    collect_contracts ?network channel steps
  ;;
end
