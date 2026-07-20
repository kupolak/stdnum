(** ISSN (International Standard Serial Number).

    The ISSN (International Standard Serial Number) is the standard code to
    identify periodical publications (e.g. magazines).

    An ISSN has 8 digits and is formatted in two pairs of 4 digits separated
    by a hyphen. The last digit is a check digit and may be 0-9 or X (similar
    to ISBN-10).

    More information:
    - https://en.wikipedia.org/wiki/International_Standard_Serial_Number
    - https://www.issn.org/ *)

open Tools

exception Invalid_format
exception Invalid_length
exception Invalid_checksum

let compact number =
  Utils.clean number "[ -]" |> String.trim |> String.uppercase_ascii

let calc_check_digit number =
  (* Calculate weighted sum: multiply each digit by (8-i) for i=0..6 *)
  let sum = ref 0 in
  for i = 0 to String.length number - 1 do
    let digit = int_of_char number.[i] - int_of_char '0' in
    sum := !sum + ((8 - i) * digit)
  done;
  let check = (11 - (!sum mod 11)) mod 11 in
  if check = 10 then "X" else string_of_int check

let validate number =
  let number = compact number in

  (* Check that first 7 characters are digits *)
  let first7 = String.sub number 0 (min 7 (String.length number)) in
  if not (Utils.is_digits first7) then raise Invalid_format;

  if String.length number <> 8 then raise Invalid_length;

  let number_part = String.sub number 0 7 in
  let check_digit = String.sub number 7 1 in
  if calc_check_digit number_part <> check_digit then raise Invalid_checksum;

  number

let is_valid number =
  try
    ignore (validate number);
    true
  with Invalid_format | Invalid_length | Invalid_checksum -> false

let format number =
  let number = compact number in
  String.sub number 0 4 ^ "-" ^ String.sub number 4 4

let to_ean ?(issue_code = "00") number =
  let number = validate number in
  let base = "977" ^ String.sub number 0 7 ^ issue_code in
  base ^ Ean.calc_check_digit base
