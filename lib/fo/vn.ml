(** V-number (Vinnutal, Faroe Islands tax number).

    In the Faroe Islands the legal persons TIN equals the V number issued by the
    Faroese Tax Administration. It is a consecutive number.

    More information:
    - https://www.taks.fo/fo/borgari/bolkar/at-stovna-virki/
    - https://www.oecd.org/tax/automatic-exchange/crs-implementation-and-assistance/tax-identification-numbers/Faroe-islands-TIN.pdf
*)

open Tools

exception Invalid_format
exception Invalid_length

let compact number =
  let number =
    Utils.clean number "[- .]" |> String.trim |> String.uppercase_ascii
  in
  if String.starts_with ~prefix:"FO" number then
    String.sub number 2 (String.length number - 2)
  else number

let validate number =
  let number = compact number in
  if String.length number <> 6 then raise Invalid_length;
  if not (Utils.is_digits number) then raise Invalid_format;
  number

let validate_result number =
  try Ok (validate number) with
  | Invalid_format -> Error Error.Invalid_format
  | Invalid_length -> Error Error.Invalid_length

let is_valid number =
  try
    ignore (validate number);
    true
  with Invalid_format | Invalid_length -> false

let format number = compact number
