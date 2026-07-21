(** UID (Umsatzsteuer-Identifikationsnummer, Austrian VAT number).

    The Austrian UID is a 9-digit number that starts with a U (optionally
    preceded with AT). The last digit is a check digit.

    More information:
    - https://en.wikipedia.org/wiki/VAT_identification_number *)

open Tools

exception Invalid_format
exception Invalid_length
exception Invalid_checksum

let compact number =
  let number =
    Utils.clean number "[ -./]" |> String.trim |> String.uppercase_ascii
  in
  if String.starts_with ~prefix:"AT" number then
    String.sub number 2 (String.length number - 2)
  else number

let calc_check_digit number =
  let luhn_chk =
    Luhn.checksum (String.sub number 1 (String.length number - 1))
  in
  let check = (6 - luhn_chk) mod 10 in
  let check = if check < 0 then check + 10 else check in
  string_of_int check

let validate number =
  let number = compact number in
  if
    String.length number = 0
    || number.[0] <> 'U'
    || not (Utils.is_digits (String.sub number 1 (String.length number - 1)))
  then raise Invalid_format;
  if String.length number <> 9 then raise Invalid_length;
  if calc_check_digit (String.sub number 0 8) <> String.sub number 8 1 then
    raise Invalid_checksum;
  number

let validate_result number =
  try Ok (validate number) with
  | Invalid_format -> Error Error.Invalid_format
  | Invalid_length -> Error Error.Invalid_length
  | Invalid_checksum -> Error Error.Invalid_checksum

let is_valid number =
  try
    ignore (validate number);
    true
  with Invalid_format | Invalid_length | Invalid_checksum -> false
