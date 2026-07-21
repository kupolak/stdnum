(** ISMN (International Standard Music Number).

    The ISMN (International Standard Music Number) is used to identify sheet
    music. This module handles both numbers in the 10-digit 13-digit format.

    More information:
    - https://en.wikipedia.org/wiki/International_Standard_Music_Number *)

open Tools

exception Invalid_format
exception Invalid_length
exception Invalid_component
exception Invalid_checksum

let compact number =
  Utils.clean number "[ -.]" |> String.trim |> String.uppercase_ascii

let validate number =
  let number = compact number in
  let len = String.length number in
  if len = 10 then begin
    if number.[0] <> 'M' then raise Invalid_format;
    begin try ignore (Ean.validate ("9790" ^ String.sub number 1 9)) with
    | Ean.Invalid_checksum -> raise Invalid_checksum
    | Ean.Invalid_format -> raise Invalid_format
    | Ean.Invalid_length -> raise Invalid_length
    end;
    number
  end
  else if len = 13 then begin
    if not (String.starts_with ~prefix:"9790" number) then
      raise Invalid_component;
    begin try ignore (Ean.validate number) with
    | Ean.Invalid_checksum -> raise Invalid_checksum
    | Ean.Invalid_format -> raise Invalid_format
    | Ean.Invalid_length -> raise Invalid_length
    end;
    number
  end
  else raise Invalid_length

let validate_result number =
  try Ok (validate number) with
  | Invalid_format -> Error Error.Invalid_format
  | Invalid_length -> Error Error.Invalid_length
  | Invalid_component -> Error Tools.Error.Invalid_component
  | Invalid_checksum -> Error Error.Invalid_checksum

let ismn_type number =
  try
    let number = validate number in
    if String.length number = 10 then Some "ISMN10" else Some "ISMN13"
  with
  | Invalid_format | Invalid_length | Invalid_component | Invalid_checksum ->
    None

let is_valid number = Result.is_ok (validate_result number)

let to_ismn13 number =
  let number_trim = String.trim number in
  let min_number = compact number_trim in
  if String.length min_number = 13 then number_trim
  else if String.contains number_trim ' ' then
    "979 0" ^ String.sub number_trim 1 (String.length number_trim - 1)
  else if String.contains number_trim '-' then
    "979-0" ^ String.sub number_trim 1 (String.length number_trim - 1)
  else "9790" ^ String.sub number_trim 1 (String.length number_trim - 1)

let ranges =
  [
    (3, "000", "099")
  ; (4, "1000", "3999")
  ; (5, "40000", "69999")
  ; (6, "700000", "899999")
  ; (7, "9000000", "9999999")
  ]

let split number =
  let number = to_ismn13 (compact number) in
  let rec find_range = function
    | [] -> failwith "unreachable"
    | (len, low, high) :: tl ->
        let sub = String.sub number 4 len in
        if String.compare low sub <= 0 && String.compare sub high <= 0 then
          ( String.sub number 0 3
          , String.sub number 3 1
          , sub
          , String.sub number (4 + len) (String.length number - 5 - len)
          , String.sub number (String.length number - 1) 1 )
        else find_range tl
  in
  find_range ranges

let format ?(separator = "-") number =
  let p1, p2, p3, p4, p5 = split number in
  let parts = [ p1; p2; p3; p4; p5 ] |> List.filter (fun s -> s <> "") in
  String.concat separator parts
