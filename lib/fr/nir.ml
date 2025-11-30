open Tools

exception Invalid_checksum
exception Invalid_length
exception Invalid_format

let compact number =
  Utils.clean number "[ .]" |> String.trim |> String.uppercase_ascii

let calc_check_digits number =
  let department = String.sub number 5 2 in
  let normalized =
    if department = "2A" then
      String.sub number 0 5 ^ "19"
      ^ String.sub number 7 (String.length number - 7)
    else if department = "2B" then
      String.sub number 0 5 ^ "18"
      ^ String.sub number 7 (String.length number - 7)
    else number
  in
  let first_13 = String.sub normalized 0 13 in
  let value = int_of_string first_13 in
  let check = 97 - (value mod 97) in
  Printf.sprintf "%02d" check

let validate number =
  let number = compact number in

  (* Check length *)
  if String.length number <> 15 then raise Invalid_length;

  (* Check format: first 5 digits must be numeric *)
  if not (Utils.is_digits (String.sub number 0 5)) then raise Invalid_format;

  (* Check format: positions 5-6 must be either digits or 2A/2B *)
  let department = String.sub number 5 2 in
  if
    (not (Utils.is_digits department))
    && department <> "2A" && department <> "2B"
  then raise Invalid_format;

  (* Check format: positions 7-14 must be digits *)
  if not (Utils.is_digits (String.sub number 7 8)) then raise Invalid_format;

  (* Validate check digits *)
  let expected_check = calc_check_digits number in
  let actual_check = String.sub number 13 2 in
  if expected_check <> actual_check then raise Invalid_checksum;

  number

let is_valid number =
  try
    ignore (validate number);
    true
  with Invalid_checksum | Invalid_length | Invalid_format -> false

let format ?(separator = " ") number =
  let number = compact number in
  let parts =
    [
      String.sub number 0 1
    ; String.sub number 1 2
    ; String.sub number 3 2
    ; String.sub number 5 2
    ; String.sub number 7 3
    ; String.sub number 10 3
    ; String.sub number 13 2
    ]
  in
  String.concat separator parts
