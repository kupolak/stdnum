open Tools

exception Invalid_length
exception Invalid_format
exception Invalid_checksum

let compact number = Utils.clean number "[ -]" |> String.trim

let calc_check_digit number =
  if String.length number <> 8 then raise Invalid_length;
  if not (Utils.is_digits number) then raise Invalid_format;

  let digits =
    Array.init 8 (fun i -> int_of_char number.[i] - int_of_char '0')
  in
  let checksum =
    ((7 * (digits.(0) + digits.(3) + digits.(6)))
    + (3 * (digits.(1) + digits.(4) + digits.(7)))
    + (9 * (digits.(2) + digits.(5))))
    mod 10
  in
  string_of_int checksum

let validate number =
  let cleaned = compact number in
  if not (Utils.is_digits cleaned) then raise Invalid_format;
  if String.length cleaned <> 9 then raise Invalid_length;

  let check_digit = calc_check_digit (String.sub cleaned 0 8) in
  if String.get cleaned 8 <> String.get check_digit 0 then
    raise Invalid_checksum;

  cleaned

let is_valid number =
  try
    let _ = validate number in
    true
  with Invalid_format | Invalid_length | Invalid_checksum -> false

let format number = compact number
