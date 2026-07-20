(** TFN (Australian Tax File Number).

    The Tax File Number (TFN) is issued by the Australian Taxation Office (ATO)
    to taxpaying individuals and organisations. A business has both a TFN and an
    Australian Business Number (ABN).

    The number consists of 8 (older numbers) or 9 digits and includes a check
    digit but otherwise without structure.

    More information:
    - https://en.wikipedia.org/wiki/Tax_file_number
    - https://www.ato.gov.au/Individuals/Tax-file-number/ *)

open Tools

exception Invalid_format
exception Invalid_length
exception Invalid_checksum

let compact number =
  Utils.clean number "[ ]" |> String.trim

let checksum number =
  let weights = [| 1; 4; 3; 7; 5; 8; 6; 9; 10 |] in
  let sum = ref 0 in
  for i = 0 to String.length number - 1 do
    let digit = int_of_char number.[i] - int_of_char '0' in
    sum := !sum + (weights.(i) * digit)
  done;
  !sum mod 11

let validate number =
  let number = compact number in
  if not (Utils.is_digits number) then raise Invalid_format;
  let len = String.length number in
  if len <> 8 && len <> 9 then raise Invalid_length;
  
  if checksum number <> 0 then raise Invalid_checksum;
    
  number

let is_valid number =
  try
    ignore (validate number);
    true
  with Invalid_format | Invalid_length | Invalid_checksum -> false

let format number =
  let number = compact number in
  String.sub number 0 3 ^ " " ^
  String.sub number 3 3 ^ " " ^
  String.sub number 6 (String.length number - 6)
