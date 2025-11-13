(** Identiteitskaartnummer, Paspoortnummer (the Dutch passport number).

    Each Dutch passport has an unique number of 9 alphanumerical characters.
    The first 2 characters are always letters and the last character is a number.
    The 6 characters in between can be either.

    The letter "O" is never used to prevent it from being confused with the number "0".
    Zeros are allowed, but are not used in numbers issued after December 2019.

    More information:
    - https://www.rvig.nl/node/356
    - https://nl.wikipedia.org/wiki/Paspoort#Nederlands_paspoort *)

open Tools

exception Invalid_format
exception Invalid_length
exception Invalid_component of string

let compact number =
  Utils.clean number "[ ]" |> String.uppercase_ascii |> String.trim

let is_letter c = c >= 'A' && c <= 'Z'
let is_digit c = c >= '0' && c <= '9'
let is_alphanumeric c = is_letter c || is_digit c

let validate number =
  let number = compact number in
  if String.length number <> 9 then raise Invalid_length;
  (* First 2 characters must be letters *)
  if not (is_letter number.[0] && is_letter number.[1]) then
    raise Invalid_format;
  (* Characters 2-7 (6 chars) must be alphanumeric *)
  for i = 2 to 7 do
    if not (is_alphanumeric number.[i]) then raise Invalid_format
  done;
  (* Last character must be a digit *)
  if not (is_digit number.[8]) then raise Invalid_format;
  (* Check for letter 'O' anywhere in the number *)
  if String.contains number 'O' then
    raise (Invalid_component "The letter 'O' is not allowed");
  number

let is_valid number =
  try
    ignore (validate number);
    true
  with Invalid_format | Invalid_length | Invalid_component _ -> false
