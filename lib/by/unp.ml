open Tools

exception Invalid_format
exception Invalid_length
exception Invalid_checksum
exception Invalid_component

(* Replace Cyrillic letters with Latin equivalents *)
let replace_cyrillic str =
  let cyrillic_pattern = "А\\|В\\|Е\\|К\\|М\\|Н\\|О\\|Р\\|С\\|Т" in
  let translate = function
    | "А" -> "A"
    | "В" -> "B"
    | "Е" -> "E"
    | "К" -> "K"
    | "М" -> "M"
    | "Н" -> "H"
    | "О" -> "O"
    | "Р" -> "P"
    | "С" -> "C"
    | "Т" -> "T"
    | s -> s
  in
  Str.global_substitute
    (Str.regexp cyrillic_pattern)
    (fun s -> translate (Str.matched_string s))
    str

let compact number =
  (* Remove spaces and convert to uppercase *)
  let cleaned =
    Utils.clean number " " |> String.uppercase_ascii |> String.trim
  in

  (* Remove УНП or UNP prefix *)
  let without_prefix =
    if String.length cleaned >= 6 then
      (* Check for УНП (3 Cyrillic chars = 6 bytes in UTF-8) *)
      if
        String.length cleaned >= 6
        && String.sub cleaned 0 6 = "\xD0\xA3\xD0\x9D\xD0\x9F"
      then String.sub cleaned 6 (String.length cleaned - 6) |> String.trim
      else if String.length cleaned >= 3 && String.sub cleaned 0 3 = "UNP" then
        String.sub cleaned 3 (String.length cleaned - 3) |> String.trim
      else cleaned
    else cleaned
  in

  (* Replace Cyrillic letters with Latin letters *)
  replace_cyrillic without_prefix

let calc_check_digit number =
  let number = compact number in
  let alphabet = "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ" in
  let weights = [| 29; 23; 19; 17; 13; 7; 5; 3 |] in

  (* Convert alphanumeric to numeric for calculation *)
  let number_for_calc =
    if Utils.is_digits number then number
    else
      (* If not all digits, convert second letter to digit *)
      let first = String.make 1 number.[0] in
      let second_idx = String.index "ABCEHKMOPT" number.[1] in
      let second = string_of_int second_idx in
      let rest = String.sub number 2 (String.length number - 2) in
      first ^ second ^ rest
  in

  (* Calculate checksum *)
  let sum = ref 0 in
  for i = 0 to 7 do
    let char_val = String.index alphabet number_for_calc.[i] in
    sum := !sum + (weights.(i) * char_val)
  done;

  let check = !sum mod 11 in
  if check > 9 then raise Invalid_checksum;
  string_of_int check

let validate number =
  let number = compact number in

  (* Check length: must be exactly 9 characters *)
  if String.length number <> 9 then raise Invalid_length;

  (* Check if positions 2-8 (0-indexed) are digits *)
  let rest = String.sub number 2 7 in
  if not (Utils.is_digits rest) then raise Invalid_format;

  (* Check first two characters *)
  let first_two = String.sub number 0 2 in
  let is_both_digits = Utils.is_digits first_two in
  let is_both_letters =
    String.length first_two = 2
    && String.contains "ABCEHKMOPT" first_two.[0]
    && String.contains "ABCEHKMOPT" first_two.[1]
  in

  if not (is_both_digits || is_both_letters) then raise Invalid_format;

  (* Check first digit is valid region *)
  if not (String.contains "1234567ABCEHKM" number.[0]) then
    raise Invalid_component;

  (* Validate check digit *)
  let expected_check = calc_check_digit number in
  let actual_check = String.make 1 number.[8] in
  if expected_check <> actual_check then raise Invalid_checksum;

  number

let is_valid number =
  try
    ignore (validate number);
    true
  with
  | Invalid_format | Invalid_length | Invalid_checksum | Invalid_component ->
    false
