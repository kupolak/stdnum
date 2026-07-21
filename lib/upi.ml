(** UPI (ISO 4914 Unique Product Identifier).

    The Unique Product Identifier (UPI) is a 12-character alphanumeric code used
    to identify over-the-counter (OTC) derivative products. It consists of the
    two-character prefix QZ, nine characters that identify the product, and one
    check character. Vowels and the letter Y are not used. The check character
    uses the ISO 7064 Mod 31, 30 algorithm.

    More information:
    - https://www.iso.org/standard/80506.html
    - https://www.anna-dsb.com/upi-/
    - https://zakon.rada.gov.ua/laws/show/z1549-21 *)

open Tools

exception Invalid_format
exception Invalid_length
exception Invalid_component
exception Invalid_checksum

let alphabet = "0123456789BCDFGHJKLMNPQRSTVWXZ"

let compact number =
  Utils.clean number "[ ]" |> String.trim |> String.uppercase_ascii

let calc_check_digit number =
  let number = compact number in
  String.make 1 (Iso7064.Mod_37_36.calc_check_digit ~alphabet number)

let validate number =
  let number = compact number in
  let check_chars s =
    let rec aux i =
      if i >= String.length s then true
      else if String.contains alphabet s.[i] then aux (i + 1)
      else false
    in
    aux 0
  in
  if not (check_chars number) then raise Invalid_format;
  if String.length number <> 12 then raise Invalid_length;
  if not (String.starts_with ~prefix:"QZ" number) then raise Invalid_component;
  begin try ignore (Iso7064.Mod_37_36.validate ~alphabet number) with
  | Iso7064.Mod_37_36.Invalid_checksum -> raise Invalid_checksum
  | Iso7064.Mod_37_36.Invalid_format -> raise Invalid_format
  end;
  number

let is_valid number =
  try
    ignore (validate number);
    true
  with
  | Invalid_format | Invalid_length | Invalid_component | Invalid_checksum ->
    false
