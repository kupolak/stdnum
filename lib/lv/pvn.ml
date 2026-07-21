(** PVN (Pievienotās vērtības nodokļa, Latvian VAT number).

    The PVN is a 11-digit number that can either be a reference to a legal
    entity (in which case the first digit > 3) or a natural person (in which
    case it should be the same as the personal code (personas kods)). Personal
    codes start "32". Older personal codes start with 6 digits to denote the
    birth date in the form ddmmyy.

    More information:
    - https://en.wikipedia.org/wiki/National_identification_number#Latvia *)

open Tools

exception Invalid_format
exception Invalid_length
exception Invalid_component
exception Invalid_checksum

let compact number =
  let number =
    Utils.clean number "[ -]" |> String.trim |> String.uppercase_ascii
  in
  if String.starts_with ~prefix:"LV" number then
    String.sub number 2 (String.length number - 2)
  else number

let checksum number =
  let weights = [| 9; 1; 4; 8; 3; 10; 2; 5; 7; 6; 1 |] in
  let check = ref 0 in
  for i = 0 to 10 do
    check := !check + (weights.(i) * (int_of_char number.[i] - int_of_char '0'))
  done;
  !check mod 11

let calc_check_digit_pers number =
  let weights = [| 10; 5; 8; 4; 2; 1; 6; 3; 7; 9 |] in
  let check = ref 1 in
  for i = 0 to 9 do
    check := !check + (weights.(i) * (int_of_char number.[i] - int_of_char '0'))
  done;
  string_of_int (!check mod 11 mod 10)

let is_valid_date year month day =
  if year < 1 || month < 1 || month > 12 || day < 1 || day > 31 then false
  else
    let days_in_month =
      match month with
      | 4 | 6 | 9 | 11 -> 30
      | 2 ->
          let is_leap =
            (year mod 4 = 0 && year mod 100 <> 0) || year mod 400 = 0
          in
          if is_leap then 29 else 28
      | _ -> 31
    in
    day <= days_in_month

let get_birth_date number =
  let number = compact number in
  let day = int_of_string (String.sub number 0 2) in
  let month = int_of_string (String.sub number 2 2) in
  let year = int_of_string (String.sub number 4 2) in
  let year = year + 1800 + ((int_of_char number.[6] - int_of_char '0') * 100) in
  if not (is_valid_date year month day) then raise Invalid_component;
  (year, month, day)

let validate number =
  let number = compact number in
  if not (Utils.is_digits number) then raise Invalid_format;
  if String.length number <> 11 then raise Invalid_length;
  if number.[0] > '3' then (if checksum number <> 3 then raise Invalid_checksum)
  else if String.starts_with ~prefix:"32" number then (
    if
      calc_check_digit_pers (String.sub number 0 10)
      <> String.make 1 number.[10]
    then raise Invalid_checksum)
  else (
    ignore (get_birth_date number);
    if
      calc_check_digit_pers (String.sub number 0 10)
      <> String.make 1 number.[10]
    then raise Invalid_checksum);
  number

let validate_result number =
  try Ok (validate number) with
  | Invalid_format -> Error Error.Invalid_format
  | Invalid_length -> Error Error.Invalid_length
  | Invalid_component -> Error Tools.Error.Invalid_component
  | Invalid_checksum -> Error Error.Invalid_checksum

let is_valid number = Result.is_ok (validate_result number)
