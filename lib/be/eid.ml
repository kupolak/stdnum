open Tools

exception Invalid_length
exception Invalid_format
exception Invalid_checksum

let compact number =
  Utils.clean number "[ ./-]" |> String.uppercase_ascii |> String.trim

let calc_check_digits number =
  (* Calculate check digits as (first 10 digits mod 97) or 97 if remainder is 0 *)
  let base_num = int_of_string (String.sub number 0 10) in
  let remainder = base_num mod 97 in
  let check = if remainder = 0 then 97 else remainder in
  Printf.sprintf "%02d" check

let format number =
  let number = compact number in
  Printf.sprintf "%s-%s-%s" (String.sub number 0 3) (String.sub number 3 7)
    (String.sub number 10 2)

let validate number =
  let number = compact number in

  if (not (Utils.is_digits number)) || int_of_string number <= 0 then
    raise Invalid_format;

  if String.length number <> 12 then raise Invalid_length;

  let expected_check = calc_check_digits number in
  let actual_check = String.sub number 10 2 in
  if expected_check <> actual_check then raise Invalid_checksum;

  number

let is_valid number =
  try
    ignore (validate number);
    true
  with Invalid_format | Invalid_length | Invalid_checksum -> false
