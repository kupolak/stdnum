(** Austrian Company Register Numbers.

    The Austrian company register number consist of digits followed by a single
    letter, e.g. "122119m". Sometimes it is presented with preceding "FN", e.g.
    "FN 122119m". *)

open Tools

exception Invalid_format

let compact number =
  let number = Utils.clean number "[ -./]" |> String.trim in
  if String.starts_with ~prefix:"FN" (String.uppercase_ascii number) then
    String.sub number 2 (String.length number - 2)
  else number

let validate number =
  let number = compact number in
  let len = String.length number in
  if len < 2 then raise Invalid_format;

  let is_digit c = c >= '0' && c <= '9' in
  let is_lower_letter c = c >= 'a' && c <= 'z' in

  let rec check_digits i =
    if i = len - 1 then ()
    else if not (is_digit number.[i]) then raise Invalid_format
    else check_digits (i + 1)
  in

  check_digits 0;
  if not (is_lower_letter number.[len - 1]) then raise Invalid_format;
  number

let validate_result number =
  try Ok (validate number) with Invalid_format -> Error Error.Invalid_format

let is_valid number =
  try
    ignore (validate number);
    true
  with Invalid_format -> false
