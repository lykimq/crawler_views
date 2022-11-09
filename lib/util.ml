let steps ~total ?(offset = 0) ~limit () =
  let total, offset, limit = abs total, abs offset, abs limit in
  let len = total - offset in
  let step = (len / limit) + 1 in
  let bound = if len mod limit = 0 then 0 else 1 in
  let init_size = step + bound in
  if init_size < 1
  then []
  else
    List.init (step + bound) (fun i ->
      let offset = offset + (i * limit) in
      offset, limit)
;;
