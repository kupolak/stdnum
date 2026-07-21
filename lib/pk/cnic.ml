(** CNIC number (Pakistani Computerised National Identity Card number).

    The CNIC (Computerised National Identity Card, قومی شناختی کارڈ) or SNIC
    (Smart National Identity Card) is issued by by Pakistan's NADRA (National
    Database and Registration Authority) to citizens of 18 years or older.

    The number consists of 13 digits and encodes the person's locality (5
    digits), followed by 7 digit serial number an a single digit indicating
    gender.

    More Information:
    - https://en.wikipedia.org/wiki/CNIC_(Pakistan)
    - https://www.nadra.gov.pk/identity/identity-cnic/ *)

open Tools

exception Invalid_format
exception Invalid_length
exception Invalid_component

let compact number = Utils.clean number "-" |> String.trim

let get_gender number =
  let number = compact number in
  if String.length number > 0 then
    match number.[String.length number - 1] with
    | '1' | '3' | '5' | '7' | '9' -> Some "M"
    | '2' | '4' | '6' | '8' -> Some "F"
    | _ -> None
  else None

let get_province number =
  let number = compact number in
  if String.length number > 0 then
    match number.[0] with
    | '1' -> Some "Khyber Pakhtunkhwa"
    | '2' -> Some "FATA"
    | '3' -> Some "Punjab"
    | '4' -> Some "Sindh"
    | '5' -> Some "Balochistan"
    | '6' -> Some "Islamabad"
    | '7' -> Some "Gilgit-Baltistan"
    | _ -> None
  else None

let validate number =
  let number = compact number in
  if not (Utils.is_digits number) then raise Invalid_format;
  if String.length number <> 13 then raise Invalid_length;
  if get_gender number = None then raise Invalid_component;
  if get_province number = None then raise Invalid_component;
  number

let validate_result number =
  try Ok (validate number) with
  | Invalid_format -> Error Error.Invalid_format
  | Invalid_length -> Error Error.Invalid_length
  | Invalid_component -> Error Tools.Error.Invalid_component

let is_valid number =
  try
    ignore (validate number);
    true
  with Invalid_format | Invalid_length | Invalid_component -> false

let format number =
  let number = compact number in
  if String.length number = 13 then
    String.sub number 0 5 ^ "-" ^ String.sub number 5 7 ^ "-"
    ^ String.sub number 12 1
  else number
