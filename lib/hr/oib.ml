(** OIB (Osobni identifikacijski broj, Croatian identification number).

    The personal identification number is used to identify persons and legal
    entities in Croatia. It has 11 digits (sometimes prefixed by HR), contains
    no personal information and uses the ISO 7064 Mod 11, 10 checksum algorithm.
*)

open Tools

exception Invalid_format
exception Invalid_length
exception Invalid_checksum

let compact number =
  let number =
    Utils.clean number "[ -]" |> String.trim |> String.uppercase_ascii
  in
  if String.starts_with ~prefix:"HR" number then
    String.sub number 2 (String.length number - 2)
  else number

let validate number =
  let number = compact number in
  if not (Utils.is_digits number) then raise Invalid_format;
  if String.length number <> 11 then raise Invalid_length;
  if not (Iso7064.Mod_11_10.is_valid number) then raise Invalid_checksum;
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
