(** EPIC (Electoral Photo Identity Card, Indian Voter ID).

    The Electoral Photo Identity Card (EPIC) is an identity document issued by
    the Election Commission of India (ECI) only to the India citizens who have
    reached the age of 18.

    Each EPIC contains an unique 10 digit alphanumeric identifier known as EPIC
    number or Voter ID number.

    Every EPIC number begins with a Functional Unique Serial Number (FUSN), a 3
    letter unique identifier for each Assembly Constituency. FUSN is followed by
    a 6 digit serial number and 1 check digit of the serial number calculated
    using Luhn algorithm.

    More information:
    - https://en.wikipedia.org/wiki/Voter_ID_(India)
    - https://www.kotaksecurities.com/ksweb/voter-id/serial-number-in-elctoral-roll
*)

open Tools

exception Invalid_format
exception Invalid_length
exception Invalid_checksum

let compact number =
  Utils.clean number "[ -]" |> String.trim |> String.uppercase_ascii

let epic_re = Str.regexp "^[A-Z][A-Z][A-Z][0-9][0-9][0-9][0-9][0-9][0-9][0-9]$"

let validate number =
  let number = compact number in
  if String.length number <> 10 then raise Invalid_length;
  if not (Str.string_match epic_re number 0) then raise Invalid_format;
  if not (Luhn.is_valid (String.sub number 3 7)) then raise Invalid_checksum;
  number

let validate_result number =
  try Ok (validate number) with
  | Invalid_format -> Error Error.Invalid_format
  | Invalid_length -> Error Error.Invalid_length
  | Invalid_checksum -> Error Error.Invalid_checksum

let is_valid number =
  try
    ignore (validate number);
    true
  with Invalid_format | Invalid_length | Invalid_checksum -> false
