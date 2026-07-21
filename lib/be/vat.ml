open Tools

exception Invalid_length
exception Invalid_format
exception Invalid_checksum
exception Invalid_component

let compact number =
  let number = String.uppercase_ascii number |> String.trim in
  (* Remove BE prefix first, before cleaning *)
  let number =
    if String.length number >= 2 && String.sub number 0 2 = "BE" then
      String.sub number 2 (String.length number - 2) |> String.trim
    else number
  in
  (* Clean spaces and separators *)
  let number = Utils.clean number " -./" in
  (* Remove (0) prefix *)
  let number =
    if String.length number >= 3 && String.sub number 0 3 = "(0)" then
      "0" ^ String.sub number 3 (String.length number - 3)
    else number
  in
  (* Add leading 0 for old 9-digit format *)
  if String.length number = 9 then "0" ^ number else number

let checksum number =
  (* Calculate (base_number + check_digits) mod 97 *)
  let base_num = int_of_string (String.sub number 0 8) in
  let check_digits = int_of_string (String.sub number 8 2) in
  (base_num + check_digits) mod 97

let validate number =
  let number = compact number in

  if (not (Utils.is_digits number)) || int_of_string number <= 0 then
    raise Invalid_format;

  if String.length number <> 10 then raise Invalid_length;

  if not (number.[0] = '0' || number.[0] = '1') then raise Invalid_component;

  if checksum number <> 0 then raise Invalid_checksum;

  number

let validate_result number =
  try Ok (validate number) with
  | Invalid_length -> Error Error.Invalid_length
  | Invalid_format -> Error Error.Invalid_format
  | Invalid_checksum -> Error Error.Invalid_checksum
  | Invalid_component -> Error Tools.Error.Invalid_component

let is_valid number = Result.is_ok (validate_result number)
