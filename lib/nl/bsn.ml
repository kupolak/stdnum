(** BSN (Burgerservicenummer, the Dutch citizen identification number).

    The BSN is a unique personal identifier and has been introduced as the
    successor to the sofinummer. It is issued to each Dutch national. The number
    consists of up to nine digits (the leading zeros are commonly omitted) and
    contains a simple checksum.

    More information:
    - https://en.wikipedia.org/wiki/National_identification_number#Netherlands
    - https://nl.wikipedia.org/wiki/Burgerservicenummer
    - https://www.burgerservicenummer.nl/ *)

open Tools

exception Invalid_format
exception Invalid_length
exception Invalid_checksum

let compact number =
  let cleaned = Utils.clean number "[ .:\\-]" |> String.trim in
  (* Pad with leading zeros to 9 digits *)
  let len = String.length cleaned in
  if len < 9 then String.make (9 - len) '0' ^ cleaned else cleaned

let checksum number =
  let sum = ref 0 in
  for i = 0 to 7 do
    let digit = int_of_char number.[i] - int_of_char '0' in
    sum := !sum + ((9 - i) * digit)
  done;
  let last_digit = int_of_char number.[8] - int_of_char '0' in
  (!sum - last_digit) mod 11

let validate number =
  let number = compact number in
  if not (Utils.is_digits number) then raise Invalid_format;
  if int_of_string number <= 0 then raise Invalid_format;
  if String.length number <> 9 then raise Invalid_length;
  if checksum number <> 0 then raise Invalid_checksum;
  number

let is_valid number =
  try
    ignore (validate number);
    true
  with Invalid_format | Invalid_length | Invalid_checksum -> false

let format number =
  let number = compact number in
  String.sub number 0 4 ^ "." ^ String.sub number 4 2 ^ "."
  ^ String.sub number 6 3
