open Tools

exception Invalid_length
exception Invalid_format
exception Invalid_checksum

(* Use the same compact function as DNI *)
let compact number =
  Utils.clean number "[ -]" |> String.uppercase_ascii |> String.trim

let calc_check_digit number =
  (* Replace XYZ with 012 *)
  let first_char = number.[0] in
  let digit_str =
    match first_char with
    | 'X' -> "0"
    | 'Y' -> "1"
    | 'Z' -> "2"
    | _ -> raise Invalid_format
  in
  let converted = digit_str ^ String.sub number 1 (String.length number - 1) in
  Dni.calc_check_digit converted

let validate number =
  let number = compact number in
  if String.length number <> 9 then raise Invalid_length;

  (* Check that first character is X, Y or Z *)
  let first_char = number.[0] in
  if first_char <> 'X' && first_char <> 'Y' && first_char <> 'Z' then
    raise Invalid_format;

  (* Check that middle characters (positions 1-7) are digits *)
  let middle = String.sub number 1 7 in
  if not (Utils.is_digits middle) then raise Invalid_format;

  (* Validate check digit *)
  let calculated = calc_check_digit (String.sub number 0 8) in
  let provided = String.sub number 8 1 in
  if calculated <> provided then raise Invalid_checksum;

  number

let is_valid number =
  try
    ignore (validate number);
    true
  with Invalid_format | Invalid_length | Invalid_checksum -> false
