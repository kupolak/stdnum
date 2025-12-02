open Tools

exception Invalid_format
exception Invalid_length
exception Invalid_checksum

let compact number =
  let cleaned =
    Utils.clean number "[ -]" |> String.uppercase_ascii |> String.trim
  in
  if String.length cleaned >= 2 && String.sub cleaned 0 2 = "SI" then
    String.sub cleaned 2 (String.length cleaned - 2)
  else cleaned

let calc_check_digit number =
  (* Calculate check digit for the first 7 digits *)
  let total = ref 0 in
  for i = 0 to 6 do
    let digit = int_of_char number.[i] - int_of_char '0' in
    let weight = 8 - i in
    total := !total + (digit * weight)
  done;
  let check = 11 - (!total mod 11) in
  (* Python: this results in a two-digit check digit for 11 which should be wrong *)
  if check = 10 then "0" else string_of_int check

let validate number =
  let number = compact number in

  (* Check if all digits and doesn't start with 0 *)
  if (not (Utils.is_digits number)) || number.[0] = '0' then
    raise Invalid_format;

  (* Check length *)
  if String.length number <> 8 then raise Invalid_length;

  (* Validate check digit *)
  let expected_check = calc_check_digit number in
  let actual_check = String.sub number 7 1 in
  if expected_check <> actual_check then raise Invalid_checksum;

  number

let is_valid number =
  try
    ignore (validate number);
    true
  with Invalid_format | Invalid_length | Invalid_checksum -> false
