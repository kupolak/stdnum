(** PAN (Permanent Account Number, Indian income tax identifier).

    The Permanent Account Number (PAN) is a 10 digit alphanumeric identifier for
    Indian individuals, families and corporates for income tax purposes. It is
    also issued to foreign nationals subject to a valid visa.

    PAN is made up of 5 letters, 4 digits and 1 alphabetic check digit. The 4th
    character indicates the type of holder, the 5th character is either 1st
    letter of the holder's name or holder's surname in case of 'Individual' PAN,
    next 4 digits are serial numbers running from 0001 to 9999 and the last
    character is a check digit computed by an undocumented checksum algorithm.

    More information:
    - https://en.wikipedia.org/wiki/Permanent_account_number
    - https://incometaxindia.gov.in/tutorials/1.permanent%20account%20number%20(pan).pdf *)

open Tools

exception Invalid_format
exception Invalid_length
exception Invalid_component

let pan_re = Str.regexp "^[A-Z][A-Z][A-Z][A-Z][A-Z][0-9][0-9][0-9][0-9][A-Z]$"

let pan_holder_types = [
  ("A", "Association of Persons (AOP)");
  ("B", "Body of Individuals (BOI)");
  ("C", "Company");
  ("F", "Firm/Limited Liability Partnership");
  ("G", "Government Agency");
  ("H", "Hindu Undivided Family (HUF)");
  ("L", "Local Authority");
  ("J", "Artificial Juridical Person");
  ("P", "Individual");
  ("T", "Trust");
  ("K", "Krish (Trust Krish)")
]

let compact number =
  Utils.clean number "[ -]" |> String.trim |> String.uppercase_ascii

let info number =
  let number = compact number in
  let c = String.sub number 3 1 in
  match List.assoc_opt c pan_holder_types with
  | Some holder_type -> (holder_type, String.sub number 4 1)
  | None -> raise Invalid_component

let validate number =
  let number = compact number in
  if String.length number <> 10 then raise Invalid_length;
  if not (Str.string_match pan_re number 0) then raise Invalid_format;
  ignore (info number);
  if String.sub number 5 4 = "0000" then raise Invalid_component;
  number

let is_valid number =
  try
    ignore (validate number);
    true
  with Invalid_format | Invalid_length | Invalid_component -> false

let mask number =
  let number = compact number in
  String.sub number 0 5 ^ "XXXX" ^ String.sub number 9 1
