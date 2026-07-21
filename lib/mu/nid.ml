(** ID number (Mauritian national identifier).

    The Mauritian national ID number is a unique 14 alphanumeric identifier
    assigned at birth to identify individuals. It is displayed on the National
    Identity Card.

    The number consists of one alphabetic character and thirteen digits:
    - the first character of the person's surname at birth
    - 2 digits for day of birth
    - 2 digits for month of birth
    - 2 digits for year of birth
    - 6 digit unique id
    - a check digit

    More information:
    - https://mnis.govmu.org/English/ID%20Card/Pages/default.aspx *)

open Tools

exception Invalid_format
exception Invalid_length
exception Invalid_checksum
exception Invalid_component

let alphabet = "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ"

let compact number =
  Utils.clean number " " |> String.trim |> String.uppercase_ascii

let calc_check_digit number =
  let check = ref 0 in
  for i = 0 to 12 do
    let char_index =
      try String.index alphabet number.[i] with Not_found -> 0
    in
    check := !check + ((14 - i) * char_index)
  done;
  String.make 1 alphabet.[(17 - (!check mod 17)) mod 17]

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

let get_date number =
  let day = int_of_string (String.sub number 1 2) in
  let month = int_of_string (String.sub number 3 2) in
  let year = int_of_string (String.sub number 5 2) + 2000 in
  if not (is_valid_date year month day) then raise Invalid_component;
  (year, month, day)

let validate number =
  let number = compact number in
  if String.length number <> 14 then raise Invalid_length;
  if
    (not (Utils.is_alpha (String.sub number 0 1)))
    || (not (Utils.is_digits (String.sub number 1 12)))
    || not (Utils.is_alnum (String.sub number 13 1))
  then raise Invalid_format;
  if String.make 1 number.[13] <> calc_check_digit number then
    raise Invalid_checksum;
  ignore (get_date number);
  number

let is_valid number =
  try
    ignore (validate number);
    true
  with
  | Invalid_format | Invalid_length | Invalid_checksum | Invalid_component ->
    false
