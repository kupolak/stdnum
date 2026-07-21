(** Company Number (מספר חברה, or short ח.פ. Israeli company number).

    It consists of nine digits and includes a check digit. For companies
    the first digit is a 5. The first two digits identify the type of
    company.

    More information:
    - https://he.wikipedia.org/wiki/תאגיד#מספר_רישום_התאגיד
    - https://www.oecd.org/tax/automatic-exchange/crs-implementation-and-assistance/tax-identification-numbers/Israel-TIN.pdf
    - https://wiki.scn.sap.com/wiki/display/CRM/Israel *)

open Tools

exception Invalid_format
exception Invalid_length
exception Invalid_checksum
exception Invalid_component

let compact number =
  Utils.clean number "[ -]" |> String.trim

let validate number =
  let number = compact number in
  if String.length number <> 9 then raise Invalid_length;
  if not (Utils.is_digits number) then raise Invalid_format;
  if number.[0] <> '5' then raise Invalid_component;
  if not (Luhn.is_valid number) then raise Invalid_checksum;
  number

let is_valid number =
  try
    ignore (validate number);
    true
  with Invalid_format | Invalid_length | Invalid_checksum | Invalid_component -> false

let format number = compact number
