open Tools

exception Invalid_length
exception Invalid_format
exception Invalid_checksum

let compact number =
  let cleaned =
    Utils.clean number "[ -]" |> String.uppercase_ascii |> String.trim
  in
  if String.length cleaned >= 2 && String.sub cleaned 0 2 = "SK" then
    String.sub cleaned 2 (String.length cleaned - 2)
  else cleaned

let checksum number = int_of_string number mod 11

let validate number =
  let number = compact number in
  if not (Utils.is_digits number) then raise Invalid_format;
  if String.length number <> 10 then raise Invalid_length;
  (* Note: The Python implementation checks if the number is a valid RC (Rodné číslo),
     and if so, accepts it as valid. This is commented as unclear in the original code.
     For now, we skip this check as the RC module is not implemented yet. *)
  if number.[0] = '0' then raise Invalid_format;
  let third_digit = int_of_char number.[2] - int_of_char '0' in
  if not (List.mem third_digit [ 2; 3; 4; 7; 8; 9 ]) then raise Invalid_format;
  if checksum number <> 0 then raise Invalid_checksum;
  number

let is_valid number =
  try
    ignore (validate number);
    true
  with Invalid_format | Invalid_length | Invalid_checksum -> false
