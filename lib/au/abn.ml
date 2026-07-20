(** ABN (Australian Business Number).

    The Australian Business Number (ABN) is an identifier issued to entities
    registered in the Australian Business Register (ABR). The number consists of
    11 digits of which the first two are check digits.

    More information:
    - https://en.wikipedia.org/wiki/Australian_Business_Number
    - https://abr.business.gov.au/ *)

open Tools

exception Invalid_format
exception Invalid_length
exception Invalid_checksum

let compact number =
  Utils.clean number "[ ]" |> String.trim

let calc_check_digits number =
  let weights = [| 3; 5; 7; 9; 11; 13; 15; 17; 19 |] in
  let sum = ref 0 in
  for i = 0 to 8 do
    let digit = int_of_char number.[i] - int_of_char '0' in
    sum := !sum + (-weights.(i) * digit)
  done;
  
  (* (s - 1) % 89 in python with negative numbers:
     In OCaml: let rem = (s - 1) mod 89. if rem < 0 then rem + 89 else rem *)
  let rem = (!sum - 1) mod 89 in
  let rem = if rem < 0 then rem + 89 else rem in
  let check = 11 + rem in
  string_of_int check

let validate number =
  let number = compact number in
  if not (Utils.is_digits number) then raise Invalid_format;
  if String.length number <> 11 then raise Invalid_length;
  
  if calc_check_digits (String.sub number 2 9) <> String.sub number 0 2 then
    raise Invalid_checksum;
    
  number

let is_valid number =
  try
    ignore (validate number);
    true
  with Invalid_format | Invalid_length | Invalid_checksum -> false

let format number =
  let number = compact number in
  String.sub number 0 2 ^ " " ^
  String.sub number 2 3 ^ " " ^
  String.sub number 5 3 ^ " " ^
  String.sub number 8 3
