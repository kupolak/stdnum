(** Abgabenkontonummer (Austrian tax identification number).

    The Austrian tax identification number (Abgabenkontonummer) consists of 2
    digits for the issuing tax office (Finanzamtsnummer) and 7 digits for the
    subject and a check digit (Steuernummer).

    More information:
    - https://de.wikipedia.org/wiki/Abgabenkontonummer *)

open Tools

exception Invalid_format
exception Invalid_length
exception Invalid_checksum

let compact number =
  Utils.clean number "[ -./,]" |> String.trim

let calc_check_digit number =
  let lookup = "0246813579" in
  let sum = ref 0 in
  for i = 0 to 7 do
    let digit = int_of_char number.[i] - int_of_char '0' in
    if i mod 2 = 1 then
      let val_from_lookup = int_of_char lookup.[digit] - int_of_char '0' in
      sum := !sum + val_from_lookup
    else
      sum := !sum + digit
  done;
  let check = (10 - (!sum mod 10)) mod 10 in
  string_of_int check

let validate number =
  let number = compact number in
  if String.length number <> 9 then raise Invalid_length;
  if not (Utils.is_digits number) then raise Invalid_format;
  if calc_check_digit number <> String.sub number 8 1 then
    raise Invalid_checksum;
  number

let is_valid number =
  try
    ignore (validate number);
    true
  with Invalid_format | Invalid_length | Invalid_checksum -> false

let format number =
  let number = compact number in
  String.sub number 0 2 ^ "-" ^ String.sub number 2 3 ^ "/" ^ String.sub number 5 4
