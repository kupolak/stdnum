exception Invalid_format
exception Invalid_checksum

let checksum number =
  let check = ref 5 in
  for i = 0 to String.length number - 1 do
    let digit = int_of_char number.[i] - int_of_char '0' in
    let c = if !check = 0 then 10 else !check in
    check := ((c * 2 mod 11) + digit) mod 10
  done;
  !check

let calc_check_digit number =
  let c = checksum number in
  let c' = if c = 0 then 10 else c in
  let intermediate = 1 - (c' * 2 mod 11) in
  (* Handle negative modulo to match Python behavior *)
  let result = ((intermediate mod 10) + 10) mod 10 in
  string_of_int result

let validate number =
  let is_valid = try checksum number = 1 with _ -> false in
  if not is_valid then raise Invalid_checksum;
  number

let is_valid number =
  try
    ignore (validate number);
    true
  with Invalid_format | Invalid_checksum -> false
