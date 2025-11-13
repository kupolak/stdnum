open Tools

exception Invalid_length
exception Invalid_format
exception Invalid_checksum

let compact number =
  (* Remove spaces, hyphens, and convert to uppercase *)
  let number =
    Utils.clean number "[ -]+" |> String.uppercase_ascii |> String.trim
  in
  (* Remove RO prefix if present *)
  if String.length number >= 2 && String.sub number 0 2 = "RO" then
    String.sub number 2 (String.length number - 2)
  else number

let calc_check_digit number =
  let weights = [| 7; 5; 3; 2; 1; 7; 5; 3; 2 |] in
  (* Pad to 9 digits with leading zeros *)
  let padded =
    let len = String.length number in
    if len < 9 then String.make (9 - len) '0' ^ number else number
  in
  let sum = ref 0 in
  for i = 0 to 8 do
    let digit = int_of_char padded.[i] - int_of_char '0' in
    sum := !sum + (weights.(i) * digit)
  done;
  let check = 10 * !sum mod 11 mod 10 in
  string_of_int check

let validate number =
  let number = compact number in
  (* Check if it contains only digits *)
  if not (Utils.is_digits number) then raise Invalid_format;
  (* Check if first digit is not 0 *)
  if String.length number > 0 && number.[0] = '0' then raise Invalid_format;
  (* Check length: 2-10 digits *)
  let len = String.length number in
  if len < 2 || len > 10 then raise Invalid_length;
  (* Validate checksum *)
  let body = String.sub number 0 (len - 1) in
  let check_digit = String.sub number (len - 1) 1 in
  if calc_check_digit body <> check_digit then raise Invalid_checksum;
  number

let is_valid number =
  try
    ignore (validate number);
    true
  with Invalid_format | Invalid_length | Invalid_checksum -> false
