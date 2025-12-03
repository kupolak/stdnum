open Tools

exception Invalid_format
exception Invalid_length
exception Invalid_checksum

let compact number =
  (* Remove spaces, dots, dashes and convert to uppercase *)
  let cleaned =
    Utils.clean number "[ .-]" |> String.uppercase_ascii |> String.trim
  in
  (* Remove CL prefix if present *)
  if String.length cleaned >= 2 && String.sub cleaned 0 2 = "CL" then
    String.sub cleaned 2 (String.length cleaned - 2)
  else cleaned

let calc_check_digit number =
  (* Calculate check digit using the formula:
     sum of (digit * weight) where weights cycle through [9,8,7,6,5,4,9,8,7...]
     The check digit is '0123456789K'[sum % 11] *)
  let s = ref 0 in
  let len = String.length number in
  for i = 0 to len - 1 do
    let digit = int_of_char number.[len - 1 - i] - int_of_char '0' in
    (* Python: 4 + (5 - i) % 6, but we need to handle negative modulo *)
    let mod_val = (5 - i) mod 6 in
    let mod_val = if mod_val < 0 then mod_val + 6 else mod_val in
    let weight = 4 + mod_val in
    s := !s + (digit * weight)
  done;
  let check_chars = "0123456789K" in
  String.make 1 check_chars.[!s mod 11]

let validate number =
  let number = compact number in

  (* Check length: should be 8 or 9 digits + check digit *)
  if String.length number < 8 || String.length number > 9 then
    raise Invalid_length;

  (* Check if all characters except the last are digits *)
  let digits_part = String.sub number 0 (String.length number - 1) in
  if not (Utils.is_digits digits_part) then raise Invalid_format;

  (* Validate check digit *)
  let expected_check = calc_check_digit digits_part in
  let actual_check = String.make 1 number.[String.length number - 1] in
  if expected_check <> actual_check then raise Invalid_checksum;

  number

let is_valid number =
  try
    ignore (validate number);
    true
  with Invalid_format | Invalid_length | Invalid_checksum -> false

let format number =
  let number = compact number in
  let len = String.length number in
  (* Format as XX.XXX.XXX-X *)
  if len < 8 then number
  else
    let prefix = String.sub number 0 (len - 7) in
    let part1 = String.sub number (len - 7) 3 in
    let part2 = String.sub number (len - 4) 3 in
    let check = String.make 1 number.[len - 1] in
    prefix ^ "." ^ part1 ^ "." ^ part2 ^ "-" ^ check
