(** Postcode (the Dutch postal code).

    The Dutch postal code consists of four numbers followed by two letters,
    separated by a single space.

    More information:
    - https://en.wikipedia.org/wiki/Postal_codes_in_the_Netherlands
    - https://nl.wikipedia.org/wiki/Postcodes_in_Nederland *)

open Tools

exception Invalid_format
exception Invalid_component

(* Letter combinations that are banned *)
let postcode_blacklist = [ "SA"; "SD"; "SS" ]

let compact number =
  let number =
    Utils.clean number "[ \\-]" |> String.uppercase_ascii |> String.trim
  in
  if String.length number >= 2 && String.sub number 0 2 = "NL" then
    String.sub number 2 (String.length number - 2)
  else number

let is_digit c = c >= '0' && c <= '9'
let is_letter c = c >= 'A' && c <= 'Z'

let validate number =
  let number = compact number in
  (* Check format: 4 digits + 2 letters *)
  if String.length number <> 6 then raise Invalid_format;
  (* First digit cannot be 0 *)
  if not (is_digit number.[0] && number.[0] <> '0') then raise Invalid_format;
  (* Next 3 characters must be digits *)
  if not (is_digit number.[1] && is_digit number.[2] && is_digit number.[3])
  then raise Invalid_format;
  (* Last 2 characters must be letters *)
  if not (is_letter number.[4] && is_letter number.[5]) then
    raise Invalid_format;
  (* Check if letter combination is blacklisted *)
  let letter_part = String.sub number 4 2 in
  if List.mem letter_part postcode_blacklist then raise Invalid_component;
  (* Return formatted version with space *)
  String.sub number 0 4 ^ " " ^ String.sub number 4 2

let is_valid number =
  try
    ignore (validate number);
    true
  with Invalid_format | Invalid_component -> false
