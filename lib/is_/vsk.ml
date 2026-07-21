(** VSK number (Virðisaukaskattsnúmer, Icelandic VAT number).

    The Icelandic VAT number is five or six digits. *)

open Tools

exception Invalid_format
exception Invalid_length

let compact number =
  let number =
    Utils.clean number " " |> String.uppercase_ascii |> String.trim
  in
  if String.starts_with ~prefix:"IS" number then
    String.sub number 2 (String.length number - 2)
  else number

let validate number =
  let number = compact number in
  if not (Utils.is_digits number) then raise Invalid_format;
  let len = String.length number in
  if len <> 5 && len <> 6 then raise Invalid_length;
  number

let is_valid number =
  try
    ignore (validate number);
    true
  with Invalid_format | Invalid_length -> false
