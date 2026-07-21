(** PIB (Poreski Identifikacioni Broj, Serbian tax identification number).

    The Serbian tax identification number consists of 9 digits where the last
    digit is a check digit. *)

open Tools

exception Invalid_format
exception Invalid_length
exception Invalid_checksum

let compact number = Utils.clean number "[ -.]" |> String.trim

let validate number =
  let number = compact number in
  if not (Utils.is_digits number) then raise Invalid_format;
  if String.length number <> 9 then raise Invalid_length;
  try
    let _ = Iso7064.Mod_11_10.validate number in
    number
  with Iso7064.Mod_11_10.Invalid_checksum -> raise Invalid_checksum

let is_valid number =
  try
    ignore (validate number);
    true
  with Invalid_format | Invalid_length | Invalid_checksum -> false
