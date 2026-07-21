(** LEI (Legal Entity Identifier).

    The Legal Entity Identifier (LEI) is used to identify legal entities for use
    in financial transactions. A LEI is a 20-character alphanumeric string that
    consists of a 4-character issuing LOU (Local Operating Unit), 2 digits that
    are often 0, 13 digits to identify the organisation and 2 check digits.

    More information:
    - https://en.wikipedia.org/wiki/Legal_Entity_Identifier *)

open Tools

exception Invalid_format
exception Invalid_checksum

let compact number =
  Utils.clean number "[ -]" |> String.trim |> String.uppercase_ascii

let validate number =
  let number = compact number in
  try
    let _ = Iso7064.Mod_97_10.validate number in
    number
  with
  | Iso7064.Mod_97_10.Invalid_format -> raise Invalid_format
  | Iso7064.Mod_97_10.Invalid_checksum -> raise Invalid_checksum

let validate_result number =
  try Ok (validate number) with
  | Invalid_format -> Error Error.Invalid_format
  | Invalid_checksum -> Error Error.Invalid_checksum

let is_valid number =
  try
    ignore (validate number);
    true
  with Invalid_format | Invalid_checksum -> false
