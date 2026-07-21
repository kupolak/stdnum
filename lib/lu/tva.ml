(** TVA (taxe sur la valeur ajoutée, Luxembourgian VAT number).

    The n° TVA (Numéro d'identification à la taxe sur la valeur ajoutée) is used
    for tax purposes in Luxembourg. The number consists of 8 digits of which the
    last two are check digits. *)

open Tools

exception Invalid_format
exception Invalid_length
exception Invalid_checksum

let compact number =
  let number =
    Utils.clean number "[ :.-]" |> String.trim |> String.uppercase_ascii
  in
  if String.starts_with ~prefix:"LU" number then
    String.sub number 2 (String.length number - 2)
  else number

let calc_check_digits number =
  Printf.sprintf "%02d" (int_of_string number mod 89)

let validate number =
  let number = compact number in
  if not (Utils.is_digits number) then raise Invalid_format;
  if String.length number <> 8 then raise Invalid_length;
  if calc_check_digits (String.sub number 0 6) <> String.sub number 6 2 then
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
