(** VÖEN (Vergi ödəyicisinin eyniləşdirmə nömrəsi, Azerbaijan tax number).

    The Vergi ödəyicisinin eyniləşdirmə nömrəsi is issued by the Azerbaijan state
    tax authorities to individuals and legal entities.

    This number consists of 10 digits. The first two digits are the code for the
    territorial administrative unit. The following six digits are a serial
    number. The ninth digit is a check digit. The tenth digit represents the
    legal status of a taxpayer: 1 for legal persons and 2 for natural persons.

    More information:
    - https://www.oecd.org/tax/automatic-exchange/crs-implementation-and-assistance/tax-identification-numbers/Azerbaijan-TIN.pdf
    - https://www.e-taxes.gov.az/ebyn/payerOrVoenChecker.jsp *)

open Tools

exception Invalid_format
exception Invalid_length
exception Invalid_component
exception Invalid_checksum

let compact number =
  let cleaned = Utils.clean number "[ ]" in
  if String.length cleaned = 9 then
    "0" ^ cleaned
  else cleaned

let calc_check_digit number =
  let weights = [| 4; 1; 8; 6; 2; 7; 5; 3 |] in
  let sum = ref 0 in
  for i = 0 to 7 do
    let digit = int_of_char number.[i] - int_of_char '0' in
    sum := !sum + (weights.(i) * digit)
  done;
  string_of_int (!sum mod 11)

let validate number =
  let number = compact number in
  if String.length number <> 10 then raise Invalid_length;
  if not (Utils.is_digits number) then raise Invalid_format;
  
  let last_digit = number.[9] in
  if last_digit <> '1' && last_digit <> '2' then raise Invalid_component;
  
  if calc_check_digit number <> String.sub number 8 1 then
    raise Invalid_checksum;
    
  number

let is_valid number =
  try
    ignore (validate number);
    true
  with Invalid_format | Invalid_length | Invalid_component | Invalid_checksum -> false
