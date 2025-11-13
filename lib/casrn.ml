(** CAS RN (Chemical Abstracts Service Registry Number).

    The CAS Registry Number is a unique identifier assigned by the Chemical
    Abstracts Service (CAS) to a chemical substance.

    More information:
    - https://en.wikipedia.org/wiki/CAS_Registry_Number *)

open Tools

exception Invalid_format
exception Invalid_length
exception Invalid_checksum

let compact number =
  let number = Utils.clean number "[ -]" |> String.trim in
  let len = String.length number in
  if len < 3 then number
  else
    (* Add hyphens in format: NNNNNNN-NN-C *)
    let check_digit = String.sub number (len - 1) 1 in
    let middle = String.sub number (len - 3) 2 in
    let front = String.sub number 0 (len - 3) in
    front ^ "-" ^ middle ^ "-" ^ check_digit

let calc_check_digit number =
  let number = Utils.clean number "[ -]" |> String.trim in
  (* Calculate weighted sum: multiply each digit by position (1-indexed from right) *)
  let sum = ref 0 in
  let len = String.length number in
  for i = 0 to len - 1 do
    let digit = int_of_char number.[len - 1 - i] - int_of_char '0' in
    sum := !sum + ((i + 1) * digit)
  done;
  string_of_int (!sum mod 10)

let validate number =
  let number = compact number in

  (* Check length: 7-12 characters (including hyphens) *)
  let len = String.length number in
  if len < 7 || len > 12 then raise Invalid_length;

  (* Check format: [1-9][0-9]{1,6}-[0-9]{2}-[0-9] *)
  let pattern = "^[1-9][0-9]+\\-[0-9][0-9]\\-[0-9]$" in
  if not (Str.string_match (Str.regexp pattern) number 0) then
    raise Invalid_format;

  (* Extract digits for checksum validation *)
  let digits_only = Utils.clean number "[-]" in
  let check_digit = String.sub digits_only (String.length digits_only - 1) 1 in
  let number_part = String.sub digits_only 0 (String.length digits_only - 1) in

  let expected_check = calc_check_digit number_part in
  if check_digit <> expected_check then raise Invalid_checksum;

  number

let is_valid number =
  try
    ignore (validate number);
    true
  with Invalid_format | Invalid_length | Invalid_checksum -> false
