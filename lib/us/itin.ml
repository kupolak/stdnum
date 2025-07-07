open Tools

exception Invalid_format

let validate number =
  let cleaned = Utils.clean number "-" |> String.trim in
  if String.length cleaned <> 9 then raise Invalid_format;
  if not (Utils.is_digits cleaned) then raise Invalid_format;
  (* ITIN validation - starts with 9, fourth digit is 7 or 8 *)
  let first_digit = String.get cleaned 0 in
  let fourth_digit = String.get cleaned 3 in
  if first_digit <> '9' || (fourth_digit <> '7' && fourth_digit <> '8') then
    raise Invalid_format;
  cleaned

let is_valid number =
  try
    ignore (validate number);
    true
  with Invalid_format -> false

let format number =
  if String.length number = 9 && Utils.is_digits number then
    String.sub number 0 3 ^ "-" ^ String.sub number 3 2 ^ "-"
    ^ String.sub number 5 4
  else number
