(** ISIL (International Standard Identifier for Libraries).

    The ISIL is the International Standard Identifier for Libraries and Related
    Organizations (ISO 15511) used to uniquely identify libraries, archives,
    museums, and similar organisations.

    The identifier can be up to 15 characters that may use digits, letters (case
    insensitive) hyphens, colons and slashes. The non-alphanumeric characters
    are part of the identifier and are not just for readability.

    More information:
    - https://biblstandard.dk/isil/
    - https://www.iso.org/standard/57332.html *)

open Tools

exception Invalid_format
exception Invalid_length
exception Invalid_component

let compact number = Utils.clean number "" |> String.trim

let is_valid_char c =
  match c with
  | '0' .. '9' | 'A' .. 'Z' | 'a' .. 'z' | '-' | ':' | '/' -> true
  | _ -> false

let check_chars number =
  let len = String.length number in
  let rec loop i =
    if i = len then true
    else if is_valid_char number.[i] then loop (i + 1)
    else false
  in
  loop 0

let validate number =
  let number = compact number in
  if not (check_chars number) then raise Invalid_format;
  if String.length number > 15 then raise Invalid_length;
  (* We skip checking the exact agency component since we don't have the full database *)
  number

let validate_result number =
  try Ok (validate number) with
  | Invalid_format -> Error Error.Invalid_format
  | Invalid_length -> Error Error.Invalid_length
  | Invalid_component -> Error Tools.Error.Invalid_component

let is_valid number =
  try
    ignore (validate number);
    true
  with Invalid_format | Invalid_length | Invalid_component -> false

let format number =
  let number = compact number in
  let parts = String.split_on_char '-' number in
  match parts with
  | [] -> number
  | head :: tail ->
      let formatted_head = String.uppercase_ascii head in
      String.concat "-" (formatted_head :: tail)
