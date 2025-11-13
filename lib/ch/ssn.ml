(** SSN, Sozialversicherungsnummer (Swiss social security number).

    The Swiss Sozialversicherungsnummer (also known as "Neue AHV Nummer") is
    used to identify individuals for taxation and pension purposes.

    The number is validated using EAN-13, though dashes are substituted for dots.
    The number must start with '756' (Swiss country code).

    More information:
    - https://en.wikipedia.org/wiki/National_identification_number#Switzerland
    - https://de.wikipedia.org/wiki/Sozialversicherungsnummer#Versichertennummer *)

open Tools

exception Invalid_format
exception Invalid_length
exception Invalid_checksum
exception Invalid_component

let compact number = Utils.clean number "[ .]" |> String.trim

(* EAN-13 checksum validation *)
let calc_check_digit number =
  let sum = ref 0 in
  for i = 0 to 11 do
    let digit = int_of_char number.[i] - int_of_char '0' in
    let weight = if i mod 2 = 0 then 1 else 3 in
    sum := !sum + (digit * weight)
  done;
  let check = (10 - (!sum mod 10)) mod 10 in
  string_of_int check

let validate number =
  let number = compact number in
  if String.length number <> 13 then raise Invalid_length;
  if not (Utils.is_digits number) then raise Invalid_format;
  if not (String.length number >= 3 && String.sub number 0 3 = "756") then
    raise Invalid_component;
  (* Validate EAN-13 checksum *)
  let check_pos = String.length number - 1 in
  let calculated = calc_check_digit (String.sub number 0 check_pos) in
  if String.make 1 number.[check_pos] <> calculated then raise Invalid_checksum;
  number

let is_valid number =
  try
    ignore (validate number);
    true
  with
  | Invalid_format | Invalid_length | Invalid_checksum | Invalid_component ->
    false

let format number =
  let num = compact number in
  String.concat "."
    [
      String.sub num 0 3
    ; String.sub num 3 4
    ; String.sub num 7 4
    ; String.sub num 11 2
    ]
