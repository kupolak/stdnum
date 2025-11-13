(** MVA (Merverdiavgift, Norwegian VAT number).

    The VAT number is the standard Norwegian organisation number
    (Organisasjonsnummer) with 'MVA' as suffix.

    More information:
    - https://en.wikipedia.org/wiki/VAT_identification_number *)

open Tools

exception Invalid_format

let compact number =
  let number =
    Utils.clean number "[ ]" |> String.uppercase_ascii |> String.trim
  in
  if String.length number >= 2 && String.sub number 0 2 = "NO" then
    String.sub number 2 (String.length number - 2)
  else number

let validate number =
  let number = compact number in
  let len = String.length number in
  if len < 3 || String.sub number (len - 3) 3 <> "MVA" then raise Invalid_format;
  (* Validate the organisation number part (first 9 digits) *)
  let orgnr_part = String.sub number 0 (len - 3) in
  ignore (Orgnr.validate orgnr_part);
  number

let is_valid number =
  try
    ignore (validate number);
    true
  with
  | Invalid_format -> false
  | Orgnr.Invalid_format | Orgnr.Invalid_length | Orgnr.Invalid_checksum ->
      false

let format number =
  let number = compact number in
  if String.length number < 9 then number
  else
    let orgnr_part = String.sub number 0 9 in
    let suffix = String.sub number 9 (String.length number - 9) in
    "NO " ^ Orgnr.format orgnr_part ^ " " ^ suffix
