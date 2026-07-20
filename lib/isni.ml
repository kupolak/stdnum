(** ISNI (International Standard Name Identifier).

    The International Standard Name Identifier (ISNI) is used to identify
    contributors to media content such as books, television programmes, and
    newspaper articles. The number consists of 16 digits where the last character
    is a check digit.

    More information:
    - https://en.wikipedia.org/wiki/International_Standard_Name_Identifier
    - https://isni.org/ *)

open Tools

exception Invalid_format
exception Invalid_length
exception Invalid_checksum

let compact number =
  Utils.clean number "[ -]" |> String.trim |> String.uppercase_ascii

let validate number =
  let number = compact number in
  let len = String.length number in
  if len <> 16 then raise Invalid_length;
  let num_part = String.sub number 0 15 in
  if not (Utils.is_digits num_part) then raise Invalid_format;
  begin try
    ignore (Iso7064.Mod_11_2.validate number)
  with Iso7064.Mod_11_2.Invalid_checksum -> raise Invalid_checksum
     | Iso7064.Mod_11_2.Invalid_format -> raise Invalid_format
  end;
  number

let is_valid number =
  try
    ignore (validate number);
    true
  with Invalid_format | Invalid_length | Invalid_checksum -> false

let format number =
  let number = compact number in
  String.sub number 0 4 ^ " " ^ String.sub number 4 4 ^ " " ^
  String.sub number 8 4 ^ " " ^ String.sub number 12 4
