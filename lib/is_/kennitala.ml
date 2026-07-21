(** Kennitala (Icelandic personal and organisation identity code).

    Module for handling Icelandic personal and organisation identity codes
    (kennitala). *)

open Tools

exception Invalid_format
exception Invalid_component
exception Invalid_checksum

let kennitala_re =
  Str.regexp "^[01234567][0-9][01][0-9][0-9][0-9][0-9][0-9][0-9][09]$"

let compact number =
  Utils.clean number "-" |> String.uppercase_ascii |> String.trim

let checksum number =
  let weights = [| 3; 2; 7; 6; 5; 4; 3; 2; 1; 0 |] in
  let sum = ref 0 in
  for i = 0 to 9 do
    sum := !sum + (weights.(i) * (int_of_char number.[i] - int_of_char '0'))
  done;
  !sum mod 11

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

let validate number =
  let number = compact number in
  if not (Str.string_match kennitala_re number 0) then raise Invalid_format;

  let day = int_of_string (String.sub number 0 2) in
  let month = int_of_string (String.sub number 2 2) in
  let year = int_of_string (String.sub number 4 2) in

  let year = if number.[9] = '9' then year + 1900 else year + 2000 in

  let day = if day >= 40 then day - 40 else day in

  if not (is_valid_date year month day) then raise Invalid_component;

  if checksum number <> 0 then raise Invalid_checksum;

  number

let is_valid number =
  try
    ignore (validate number);
    true
  with Invalid_format | Invalid_component | Invalid_checksum -> false

let format number =
  let number = compact number in
  String.sub number 0 6 ^ "-" ^ String.sub number 6 4
