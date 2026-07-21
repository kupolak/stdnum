(** ЕДБ (Едниствен Даночен Број, North Macedonia tax number).

    This number consists of 13 digits, sometimes with an additional "MK" prefix.

    More information:
    - http://www.ujp.gov.mk/en *)

open Tools

exception Invalid_format
exception Invalid_length
exception Invalid_checksum

let compact number =
  let number = Utils.clean number "[ -]" |> String.trim |> String.uppercase_ascii in
  let len = String.length number in
  if len >= 2 && String.sub number 0 2 = "MK" then
    String.sub number 2 (len - 2)
  else if len >= 4 && String.sub number 0 4 = "\208\156\208\154" then
    (* МК in Cyrillic is D0 9C D0 9A in UTF-8, which is 4 bytes long *)
    String.sub number 4 (len - 4)
  else number

let calc_check_digit number =
  let weights = [| 7; 6; 5; 4; 3; 2; 7; 6; 5; 4; 3; 2 |] in
  let check = ref 0 in
  for i = 0 to 11 do
    check := !check + (weights.(i) * (int_of_char number.[i] - int_of_char '0'))
  done;
  string_of_int (((- !check) mod 11 + 11) mod 11 mod 10)

let validate number =
  let number = compact number in
  if not (Utils.is_digits number) then raise Invalid_format;
  if String.length number <> 13 then raise Invalid_length;
  if String.make 1 number.[12] <> calc_check_digit number then raise Invalid_checksum;
  number

let is_valid number =
  try
    ignore (validate number);
    true
  with Invalid_format | Invalid_length | Invalid_checksum -> false

let format number = compact number
