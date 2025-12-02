open Tools

exception Invalid_format
exception Invalid_length
exception Invalid_component

(** Pad a string with leading zeros to reach the specified width. *)
let pad_with_zeros width str =
  let len = String.length str in
  if len >= width then str else String.make (width - len) '0' ^ str

(** Convert the number to the minimal representation.

    This strips the number of any valid separators and removes surrounding
    whitespace. Also adds padding zeroes if necessary. *)
let compact number =
  let number = String.trim number in
  let number = String.map (fun c -> if c = '-' then ' ' else c) number in
  let parts = String.split_on_char ' ' number in
  let parts = List.filter (fun s -> s <> "") parts in

  (* If we have exactly 3 parts, we have separators - format each part *)
  let number =
    match parts with
    | [ p; t; a ] ->
        (* We have 3 parts: pad each one *)
        let p = pad_with_zeros 2 p in
        let t = pad_with_zeros 4 t in
        let a = pad_with_zeros 4 a in
        p ^ t ^ a
    | _ ->
        (* No separators or wrong number of parts *)
        let number = String.concat "" parts in
        let len = String.length number in
        (* Only do special parsing if we have 9 digits *)
        if len = 9 then
          (* Format: P + TTTT + AAAA *)
          let p = String.sub number 0 1 in
          let t = String.sub number 1 4 in
          let a = String.sub number 5 4 in
          let p = pad_with_zeros 2 p in
          let t = pad_with_zeros 4 t in
          let a = pad_with_zeros 4 a in
          p ^ t ^ a
        else (* Return as-is *)
          number
  in

  number

(** Check if the number is a valid Costa Rica CPF number.

    This checks the length and formatting. *)
let validate number =
  let number = compact number in
  if String.length number <> 10 then raise Invalid_length;
  if not (Utils.is_digits number) then raise Invalid_format;
  if number.[0] <> '0' then raise Invalid_component;
  number

(** Check if the number is a valid Costa Rica CPF number. *)
let is_valid number =
  try
    let _ = validate number in
    true
  with Invalid_format | Invalid_length | Invalid_component -> false

(** Reformat the number to the standard presentation format. *)
let format number =
  let number = compact number in
  Printf.sprintf "%s-%s-%s" (String.sub number 0 2) (String.sub number 2 4)
    (String.sub number 6 4)
