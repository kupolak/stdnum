(** EAN (International Article Number).

    Module for handling EAN (International Article Number) codes. This
    module handles numbers in EAN-13, EAN-8, UPC (12-digit) and GTIN (EAN-14) format.

    More information:
    - https://en.wikipedia.org/wiki/International_Article_Number *)

open Tools

exception Invalid_format
exception Invalid_length
exception Invalid_checksum

let compact number = Utils.clean number "[ -]" |> String.trim

let calc_check_digit number =
  (* EAN check digit: alternately multiply by 3 and 1 from right to left *)
  let sum = ref 0 in
  let len = String.length number in
  for i = 0 to len - 1 do
    let digit = int_of_char number.[len - 1 - i] - int_of_char '0' in
    let multiplier = if i mod 2 = 0 then 3 else 1 in
    sum := !sum + (multiplier * digit)
  done;
  string_of_int ((10 - (!sum mod 10)) mod 10)

let validate number =
  let number = compact number in

  (* Check that all characters are digits *)
  if not (Utils.is_digits number) then raise Invalid_format;

  (* Check length: must be 8, 12, 13, or 14 digits *)
  let len = String.length number in
  if len <> 8 && len <> 12 && len <> 13 && len <> 14 then raise Invalid_length;

  (* Verify check digit *)
  let check_digit = String.sub number (len - 1) 1 in
  let number_part = String.sub number 0 (len - 1) in
  let expected_check = calc_check_digit number_part in
  if check_digit <> expected_check then raise Invalid_checksum;

  number

let is_valid number =
  try
    ignore (validate number);
    true
  with Invalid_format | Invalid_length | Invalid_checksum -> false
