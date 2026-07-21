(** PIB (Poreski Identifikacioni Broj, Montenegro tax number).

    This number consists of 8 digits.

    More information:
    - http://www.pretraga.crps.me:8083/
    - https://www.vatify.eu/montenegro-vat-number.html *)

open Tools

exception Invalid_format
exception Invalid_length
exception Invalid_checksum

let compact number =
  Utils.clean number " " |> String.trim

let calc_check_digit number =
  let weights = [| 8; 7; 6; 5; 4; 3; 2 |] in
  let check = ref 0 in
  for i = 0 to 6 do
    check := !check + (weights.(i) * (int_of_char number.[i] - int_of_char '0'))
  done;
  string_of_int (((- !check) mod 11 + 11) mod 11 mod 10)

let validate number =
  let number = compact number in
  if not (Utils.is_digits number) then raise Invalid_format;
  if String.length number <> 8 then raise Invalid_length;
  if String.make 1 number.[7] <> calc_check_digit number then raise Invalid_checksum;
  number

let is_valid number =
  try
    ignore (validate number);
    true
  with Invalid_format | Invalid_length | Invalid_checksum -> false

let format number = compact number
