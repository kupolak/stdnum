(** RUC number (Registro Único de Contribuyentes, Paraguay tax number).

    The Registro Único del Contribuyente (RUC) is the unique taxpayer registry
    that maintains identification numbers for all persons (national or foreign)
    and legal entities in Paraguay.

    The RUC number for legal entities consists of 8 digits starting after
    80000000. Number for residents and foreigners are up to 9 digits. The last
    digit is a check digit.

    More information:
    - https://www.ruc.com.py/ *)

open Tools

exception Invalid_format
exception Invalid_length
exception Invalid_checksum

let compact number =
  Utils.clean number "[ -]" |> String.uppercase_ascii |> String.trim

let calc_check_digit number =
  let len = String.length number in
  let s = ref 0 in
  for i = 0 to len - 1 do
    let n = int_of_char number.[len - 1 - i] - int_of_char '0' in
    s := !s + ((i + 2) * n)
  done;
  let rem = (- !s) mod 11 in
  let rem = if rem < 0 then rem + 11 else rem in
  let rem = rem mod 10 in
  string_of_int rem

let validate number =
  let number = compact number in
  if String.length number > 9 then raise Invalid_length;
  if not (Utils.is_digits number) then raise Invalid_format;
  let base = String.sub number 0 (String.length number - 1) in
  let check = String.sub number (String.length number - 1) 1 in
  if calc_check_digit base <> check then raise Invalid_checksum;
  number

let is_valid number =
  try
    ignore (validate number);
    true
  with Invalid_format | Invalid_length | Invalid_checksum -> false

let format number =
  let number = compact number in
  let len = String.length number in
  if len > 1 then
    String.sub number 0 (len - 1) ^ "-" ^ String.sub number (len - 1) 1
  else number
