(** NUIT (Número Único de Identificação Tributaria, Mozambique tax number).

    This number consists of 9 digits, sometimes separated in three groups of three
    digits using whitespace to make it easier to read.

    The first digit indicates the type of entity. The next seven digits are a
    sequential number. The last digit is the check digit, which is used to verify
    the number was correctly typed.

    More information:
    - https://www.mobilize.org.mz/nuit-numero-unico-de-identificacao-tributaria/
    - https://www.at.gov.mz/por/Perguntas-Frequentes2/NUIT *)

open Tools

exception Invalid_format
exception Invalid_length
exception Invalid_checksum

let compact number =
  Utils.clean number "[ -.]" |> String.trim

let calc_check_digit number =
  let weights = [| 8; 9; 4; 5; 6; 7; 8; 9 |] in
  let check = ref 0 in
  for i = 0 to 7 do
    check := !check + (weights.(i) * (int_of_char number.[i] - int_of_char '0'))
  done;
  let checks = "01234567891" in
  String.make 1 checks.[!check mod 11]

let validate number =
  let number = compact number in
  if String.length number <> 9 then raise Invalid_length;
  if not (Utils.is_digits number) then raise Invalid_format;
  if String.make 1 number.[8] <> calc_check_digit (String.sub number 0 8) then
    raise Invalid_checksum;
  number

let is_valid number =
  try
    ignore (validate number);
    true
  with Invalid_format | Invalid_length | Invalid_checksum -> false

let format number =
  let number = compact number in
  String.sub number 0 3 ^ " " ^ String.sub number 3 3 ^ " " ^ String.sub number 6 3
