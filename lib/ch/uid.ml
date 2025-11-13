(** UID (Unternehmens-Identifikationsnummer, Swiss business identifier).

    The Swiss UID is used to uniquely identify businesses for taxation purposes.
    The number consists of a fixed "CHE" prefix, followed by 9 digits that are
    protected with a simple checksum.

    This module only supports the "new" format that was introduced in 2011 which
    completely replaced the "old" 6-digit format in 2014.
    Stripped numbers without the CHE prefix are allowed and validated,
    but are returned with the prefix prepended.

    More information:
    - https://www.uid.admin.ch/
    - https://de.wikipedia.org/wiki/Unternehmens-Identifikationsnummer *)

open Tools

exception Invalid_format
exception Invalid_length
exception Invalid_checksum
exception Invalid_component

let compact number =
  let number =
    Utils.clean number "[ .\\-]" |> String.trim |> String.uppercase_ascii
  in
  (* If it's 9 digits, prepend CHE *)
  if String.length number = 9 && Utils.is_digits number then "CHE" ^ number
  else number

let calc_check_digit number =
  let weights = [| 5; 4; 3; 2; 7; 6; 5; 4 |] in
  let sum = ref 0 in
  for i = 0 to 7 do
    let digit = int_of_char number.[i] - int_of_char '0' in
    sum := !sum + (weights.(i) * digit)
  done;
  string_of_int ((11 - (!sum mod 11)) mod 11)

let validate number =
  let number = compact number in
  if String.length number <> 12 then raise Invalid_length;
  if not (String.length number >= 3 && String.sub number 0 3 = "CHE") then
    raise Invalid_component;
  let digit_part = String.sub number 3 9 in
  if not (Utils.is_digits digit_part) then raise Invalid_format;
  let check_pos = String.length number - 1 in
  let calculated = calc_check_digit (String.sub number 3 8) in
  if String.make 1 number.[check_pos] <> calculated then raise Invalid_checksum;
  number

let is_valid number =
  try
    ignore (validate number);
    true
  with
  | Invalid_format | Invalid_length | Invalid_checksum | Invalid_component ->
    false

let format number =
  let num = compact number in
  let prefix = String.sub num 0 3 in
  let part1 = String.sub num 3 3 in
  let part2 = String.sub num 6 3 in
  let part3 = String.sub num 9 3 in
  prefix ^ "-" ^ part1 ^ "." ^ part2 ^ "." ^ part3
