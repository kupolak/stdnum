(** Identity Number (Mispar Zehut, מספר זהות, Israeli identity number).

    The identity number (Mispar Zehut, מספר זהות) is issued at birth to Israeli
    citizens. The number consists of nine digits and includes a check digit.

    More information:
    - https://en.wikipedia.org/wiki/National_identification_number#Israel
    - https://en.wikipedia.org/wiki/Israeli_identity_card
    - https://he.wikipedia.org/wiki/מספר_זהות_(ישראל) *)

open Tools

exception Invalid_format
exception Invalid_length
exception Invalid_checksum

let compact number =
  let number = Utils.clean number "[ -]" |> String.trim in
  let len = String.length number in
  if len < 9 then String.make (9 - len) '0' ^ number else number

let validate number =
  let number = compact number in
  if String.length number > 9 then raise Invalid_length;
  if not (Utils.is_digits number) then raise Invalid_format;
  if number = "000000000" then raise Invalid_format;
  if not (Luhn.is_valid number) then raise Invalid_checksum;
  number

let is_valid number =
  try
    ignore (validate number);
    true
  with Invalid_format | Invalid_length | Invalid_checksum -> false

let format number =
  let number = compact number in
  String.sub number 0 8 ^ "-" ^ String.sub number 8 1
