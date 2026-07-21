(** NIFp (Numéro d'Identification Fiscale Permanent, Guinea tax number).

    This number consists of 9 digits, usually separated into three groups using
    hyphens to make it easier to read. The first eight digits are assigned in a
    pseudorandom manner. The last digit is the check digit.

    More information:
    - https://dgi.gov.gn/wp-content/uploads/2022/09/N%C2%B0-12-Cahier-de-Charges-NIF-p.pdf *)

open Tools

exception Invalid_format
exception Invalid_length
exception Invalid_checksum

let compact number = Utils.clean number "[ -]" |> String.trim

let validate number =
  let number = compact number in
  if String.length number <> 9 then raise Invalid_length;
  if not (Utils.is_digits number) then raise Invalid_format;
  
  if not (Luhn.is_valid number) then raise Invalid_checksum;
  number

let is_valid number =
  try
    ignore (validate number);
    true
  with Invalid_format | Invalid_length | Invalid_checksum -> false

let format number =
  let number = compact number in
  String.sub number 0 3 ^ "-" ^ String.sub number 3 3 ^ "-" ^ String.sub number 6 3
