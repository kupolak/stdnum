(** Btw-identificatienummer (Omzetbelastingnummer, the Dutch VAT number).

    The btw-identificatienummer (previously the btw-nummer) is the Dutch number
    for identifying parties in a transaction for which VAT is due. The btw-nummer
    is used in communication with the tax agency while the
    btw-identificatienummer (EORI-nummer) can be used when dealing with other
    companies though they are used interchangeably.

    The btw-nummer consists of a RSIN or BSN followed by the letter B and two
    digits that identify the number of the company created. The
    btw-identificatienummer has a similar format but different checksum and does
    not contain the BSN.

    More information:
    - https://en.wikipedia.org/wiki/VAT_identification_number
    - https://nl.wikipedia.org/wiki/Btw-nummer_(Nederland) *)

open Tools

exception Invalid_format
exception Invalid_length
exception Invalid_checksum

let compact number =
  let number =
    Utils.clean number "[ .:\\-]" |> String.uppercase_ascii |> String.trim
  in
  let number =
    if String.length number >= 2 && String.sub number 0 2 = "NL" then
      String.sub number 2 (String.length number - 2)
    else number
  in
  (* Split into BSN part and suffix (BXX) *)
  let len = String.length number in
  if len >= 3 then
    let suffix_start = len - 3 in
    let bsn_part = String.sub number 0 suffix_start in
    let suffix = String.sub number suffix_start 3 in
    Bsn.compact bsn_part ^ suffix
  else number

let validate number =
  let number = compact number in
  (* Check first 9 characters are digits and not zero *)
  if
    (not (Utils.is_digits (String.sub number 0 9)))
    || int_of_string (String.sub number 0 9) <= 0
  then raise Invalid_format;
  (* Check last 2 characters are digits and not zero *)
  if
    (not (Utils.is_digits (String.sub number 10 2)))
    || int_of_string (String.sub number 10 2) <= 0
  then raise Invalid_format;
  if String.length number <> 12 then raise Invalid_length;
  if number.[9] <> 'B' then raise Invalid_format;
  (* Check if it's valid BSN or valid mod 97-10 *)
  if not (Bsn.is_valid (String.sub number 0 9)) then
    if not (Iso7064.Mod_97_10.is_valid ("NL" ^ number)) then
      raise Invalid_checksum;
  number

let is_valid number =
  try
    ignore (validate number);
    true
  with Invalid_format | Invalid_length | Invalid_checksum -> false
