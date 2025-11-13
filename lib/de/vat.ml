(** Ust ID Nr. (Umsatzsteur Identifikationnummer, German VAT number).

    The number is 9 digits long and uses the ISO 7064 Mod 11, 10 check digit
    algorithm.

    More information:
    - https://ec.europa.eu/taxation_customs/vies/ *)

open Tools

exception Invalid_format
exception Invalid_length
exception Invalid_checksum

let compact number =
  let number =
    Utils.clean number "[ \\-./,]" |> String.uppercase_ascii |> String.trim
  in
  if String.length number >= 2 && String.sub number 0 2 = "DE" then
    String.sub number 2 (String.length number - 2)
  else number

let validate number =
  let number = compact number in
  if
    (not (Utils.is_digits number))
    || (String.length number > 0 && number.[0] = '0')
  then raise Invalid_format;
  if String.length number <> 9 then raise Invalid_length;
  (try ignore (Iso7064.Mod_11_10.validate number)
   with Iso7064.Mod_11_10.Invalid_checksum -> raise Invalid_checksum);
  number

let is_valid number =
  try
    ignore (validate number);
    true
  with Invalid_format | Invalid_length | Invalid_checksum -> false
