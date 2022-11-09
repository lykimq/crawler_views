open Cohttp
module U = Cohttp_lwt_unix

let get ?(headers = []) url callback =
  let open Lwt.Syntax in
  let headers = Header.of_list headers in
  let uri = Uri.of_string (Api.to_string url) in
  let* response, body = U.Client.get ~headers uri in
  callback response body
;;

module Contract = struct
  let count ?network () =
    let open Lwt.Syntax in
    let url = Api.Contract.count ?network () in
    get url (fun _response body ->
      let+ body = Cohttp_lwt.Body.to_string body in
      int_of_string body)
  ;;
end
