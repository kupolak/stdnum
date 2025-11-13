(** BRIN number (the Dutch school identification number).

    The BRIN (Basisregistratie Instellingen) is a number to identify schools and
    related institutions. The number consists of four alphanumeric characters,
    sometimes extended with two digits to indicate the site (this complete code
    is called the vestigingsnummer).

    More information:
    - https://nl.wikipedia.org/wiki/Basisregistratie_Instellingen *)

open Tools

exception Invalid_format
exception Invalid_length

let compact number =
  Utils.clean number "[ .:\\-]" |> String.uppercase_ascii |> String.trim

let is_digit c = c >= '0' && c <= '9'
let is_letter c = (c >= 'A' && c <= 'Z') || (c >= 'a' && c <= 'z')

let validate number =
  let number = compact number in
  let len = String.length number in
  if len <> 4 && len <> 6 then raise Invalid_length;
  (* First two characters must be digits *)
  if not (is_digit number.[0] && is_digit number.[1]) then raise Invalid_format;
  (* Next two characters must be letters *)
  if not (is_letter number.[2] && is_letter number.[3]) then
    raise Invalid_format;
  (* If length is 6, last two characters must be digits (location code) *)
  if len = 6 && not (is_digit number.[4] && is_digit number.[5]) then
    raise Invalid_format;
  number

let is_valid number =
  try
    ignore (validate number);
    true
  with Invalid_format | Invalid_length -> false
