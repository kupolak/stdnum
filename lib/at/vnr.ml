(** VNR, SVNR, VSNR (Versicherungsnummer, Austrian social security number).

    The Austian Versicherungsnummer is a personal identification number used for
    social security. The number is 10 digits long and consists of a 3 digit
    serial, a check digit and 6 digits that usually specify the person's birth
    date.

    More information:
    - https://de.wikipedia.org/wiki/Sozialversicherungsnummer#Österreich *)

open Tools

exception Invalid_format
exception Invalid_length
exception Invalid_checksum

let compact number = Utils.clean number "[ ]"

let calc_check_digit number =
  let weights = [| 3; 7; 9; 0; 5; 8; 4; 2; 1; 6 |] in
  let sum = ref 0 in
  for i = 0 to 9 do
    let digit = int_of_char number.[i] - int_of_char '0' in
    sum := !sum + (weights.(i) * digit)
  done;
  string_of_int (!sum mod 11)

let validate number =
  let number = compact number in
  if (not (Utils.is_digits number)) || String.starts_with ~prefix:"0" number
  then raise Invalid_format;
  if String.length number <> 10 then raise Invalid_length;
  if calc_check_digit number <> String.sub number 3 1 then
    raise Invalid_checksum;
  number

let is_valid number =
  try
    ignore (validate number);
    true
  with Invalid_format | Invalid_length | Invalid_checksum -> false
