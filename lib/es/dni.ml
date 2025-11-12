open Tools

exception Invalid_length
exception Invalid_format
exception Invalid_checksum

let compact number =
  Utils.clean number "[ -]" |> String.uppercase_ascii |> String.trim

let calc_check_digit number =
  (* Calculate the check digit using modulo 23 *)
  let alphabet = "TRWAGMYFPDXBNJZSQVHLCKE" in
  let value = int_of_string number mod 23 in
  String.make 1 alphabet.[value]

let validate number =
  let number = compact number in
  if String.length number <> 9 then raise Invalid_length;

  (* Check that first 8 characters are digits *)
  let digits = String.sub number 0 8 in
  if not (Utils.is_digits digits) then raise Invalid_format;

  (* Validate check digit *)
  let calculated = calc_check_digit digits in
  let provided = String.sub number 8 1 in
  if calculated <> provided then raise Invalid_checksum;

  number

let is_valid number =
  try
    ignore (validate number);
    true
  with Invalid_format | Invalid_length | Invalid_checksum -> false
