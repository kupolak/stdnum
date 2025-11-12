open Tools

exception Invalid_length
exception Invalid_format
exception Invalid_checksum
exception Invalid_component

let compact number =
  let number =
    Utils.clean number "[ /]" |> String.uppercase_ascii |> String.trim
  in
  if String.length number > 2 && String.sub number 0 2 = "CZ" then
    String.sub number 2 (String.length number - 2)
  else number

let calc_check_digit_legal number =
  (* Calculate check digit for 8-digit legal entities (7 digits + check digit) *)
  let total = ref 0 in
  for i = 0 to 6 do
    let digit = int_of_char number.[i] - int_of_char '0' in
    total := !total + ((8 - i) * digit)
  done;
  let check = (11 - (!total mod 11)) mod 11 in
  let check = if check = 0 then 1 else check in
  string_of_int (check mod 10)

let calc_check_digit_special number =
  (* Calculate check digit for special cases (9 digits starting with 6) *)
  (* Number passed should be 7 digits (skip first and last digit) *)
  let total = ref 0 in
  for i = 0 to 6 do
    let digit = int_of_char number.[i] - int_of_char '0' in
    total := !total + ((8 - i) * digit)
  done;
  let check = !total mod 11 in
  let result = (8 - ((10 - check) mod 11)) mod 10 in
  string_of_int result

let validate number =
  let number = compact number in
  if not (Utils.is_digits number) then raise Invalid_format;

  let len = String.length number in

  if len = 8 then (
    (* Legal entities - 8 digit numbers *)
    if number.[0] = '9' then raise Invalid_component;
    let base = String.sub number 0 7 in
    let check = String.sub number 7 1 in
    if calc_check_digit_legal base <> check then raise Invalid_checksum)
  else if len = 9 && number.[0] = '6' then (
    (* Special cases - 9 digit numbers starting with 6 *)
    let middle = String.sub number 1 7 in
    let check = String.sub number 8 1 in
    if calc_check_digit_special middle <> check then raise Invalid_checksum)
  else if len = 9 || len = 10 then
    (* 9 or 10 digit individual - must be valid RČ *)
    try ignore (Rc.validate number) with
    | Rc.Invalid_format -> raise Invalid_format
    | Rc.Invalid_length -> raise Invalid_length
    | Rc.Invalid_checksum -> raise Invalid_checksum
    | Rc.Invalid_component -> raise Invalid_component
  else raise Invalid_length;

  number

let is_valid number =
  try
    ignore (validate number);
    true
  with
  | Invalid_format | Invalid_length | Invalid_checksum | Invalid_component ->
    false
