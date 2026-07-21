(** PIN (Personal Identification Number, Kenya tax number).

    The Personal Identification Number (KRA PIN) is an 11 digit unique number
    that is issued by Kenya Revenue Authority (KRA) for purposes of transacting
    business with KRA, other Government agencies and service providers. It can
    be issued for individuals and non-individuals like companies, schools,
    organisations, etc.

    The number consists of 11 characters, where the first one is an A (for
    individuals) or a P (for non-individuals), the last one is a letter, and the
    rest are digits.

    More information:
    - https://www.kra.go.ke/individual/individual-pin-registration/learn-about-pin/about-pin
    - https://itax.kra.go.ke/KRA-Portal/pinChecker.htm *)

open Tools

exception Invalid_format
exception Invalid_length

let pin_re =
  Str.regexp "^[AP][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][A-Z]$"

let compact number =
  Utils.clean number "[ -]" |> String.trim |> String.uppercase_ascii

let validate number =
  let number = compact number in
  if String.length number <> 11 then raise Invalid_length;
  if not (Str.string_match pin_re number 0) then raise Invalid_format;
  number

let is_valid number =
  try
    ignore (validate number);
    true
  with Invalid_format | Invalid_length -> false

let format number = compact number
