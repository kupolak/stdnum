(** HETU (Henkilötunnus, Finnish personal identity code).

    Module for handling Finnish personal identity codes (HETU, Henkilötunnus).
    See https://www.vaestorekisterikeskus.fi/default.aspx?id=45 for checksum
    calculation details and
    https://tarkistusmerkit.teppovuori.fi/tarkmerk.htm#hetu1 for historical
    details. *)

open Tools

exception Invalid_format
exception Invalid_length
exception Invalid_component
exception Invalid_checksum

let compact number =
  Utils.clean number "" |> String.trim |> String.uppercase_ascii

let format number = compact number

let century_code = function
  | '+' -> 1800
  | '-' | 'Y' | 'X' | 'W' | 'V' | 'U' -> 1900
  | 'A' | 'B' | 'C' | 'D' | 'E' | 'F' -> 2000
  | _ -> raise Invalid_format

let is_valid_control_char c =
  let valid = "0123456789ABCDEFHJKLMNPRSTUVWXY" in
  String.contains valid c

let is_valid_date year month day =
  if month < 1 || month > 12 then false
  else if day < 1 || day > 31 then false
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

let calc_checksum number =
  let valid = "0123456789ABCDEFHJKLMNPRSTUVWXY" in
  let num = int_of_string number in
  String.make 1 valid.[num mod 31]

let validate ?(allow_temporary = false) number =
  let number = compact number in
  if String.length number <> 11 then raise Invalid_length;

  let day_str = String.sub number 0 2 in
  let month_str = String.sub number 2 2 in
  let year_str = String.sub number 4 2 in
  let century_char = number.[6] in
  let individual_str = String.sub number 7 3 in
  let control_char = String.sub number 10 1 in

  if
    (not (Utils.is_digits day_str))
    || (not (Utils.is_digits month_str))
    || (not (Utils.is_digits year_str))
    || not (Utils.is_digits individual_str)
  then raise Invalid_format;

  if not (is_valid_control_char control_char.[0]) then raise Invalid_format;

  let century = century_code century_char in
  let day = int_of_string day_str in
  let month = int_of_string month_str in
  let year = int_of_string year_str in
  let individual = int_of_string individual_str in

  (* check if birth date is valid *)
  let full_year = century + year in
  if not (is_valid_date full_year month day) then raise Invalid_component;

  (* for historical reasons individual IDs start from 002 *)
  if individual < 2 then raise Invalid_component;

  (* this range is for temporary identifiers *)
  if individual >= 900 && individual <= 999 && not allow_temporary then
    raise Invalid_component;

  let checkable_number =
    Printf.sprintf "%02d%02d%02d%03d" day month year individual
  in
  if control_char <> calc_checksum checkable_number then raise Invalid_checksum;

  number

let is_valid ?(allow_temporary = false) number =
  try
    ignore (validate ~allow_temporary number);
    true
  with
  | Invalid_format | Invalid_length | Invalid_component | Invalid_checksum ->
    false
