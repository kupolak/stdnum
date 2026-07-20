(** Belgian OGM-VCS.

    The OGM-VCS is used in bank transfer as structured communication.

    More information:
    - https://febelfin.be/en/publications/2023/febelfin-banking-standards-for-online-banking *)

open Tools

exception Invalid_format
exception Invalid_length
exception Invalid_checksum

let compact number =
  Utils.clean number "[ +/]" |> String.trim

let calc_check_digits number =
  let number = compact number in
  let prefix = String.sub number 0 10 in
  let mod_val = Int64.to_int (Int64.rem (Int64.of_string prefix) 97L) in
  let check = if mod_val = 0 then 97 else mod_val in
  Printf.sprintf "%02d" check

let validate number =
  let number = compact number in
  if not (Utils.is_digits number) then raise Invalid_format;
  
  let is_all_zeros = String.length number > 0 && String.for_all (fun c -> c = '0') number in
  if is_all_zeros then raise Invalid_format;
  
  if String.length number <> 12 then raise Invalid_length;
  
  if calc_check_digits number <> String.sub number 10 2 then
    raise Invalid_checksum;
    
  number

let is_valid number =
  try
    ignore (validate number);
    true
  with Invalid_format | Invalid_length | Invalid_checksum -> false

let format number =
  let number = compact number in
  let padded =
    let len = String.length number in
    if len < 12 then String.make (12 - len) '0' ^ number else number
  in
  String.sub padded 0 3 ^ "/" ^
  String.sub padded 3 4 ^ "/" ^
  String.sub padded 7 5
