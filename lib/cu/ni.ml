(** NI (Número de identidad, Cuban identity card numbers).

    Número de carnet de identidad is the Cuban national identifier that is
    assigned to residents. The number consists of 11 digits and include the date
    of birth of the person and gender.

    More information:
    - https://www.postdata.club/issues/201609/es-usted-unico-en-cuba.html *)

open Tools

exception Invalid_format
exception Invalid_length
exception Invalid_component

let compact number = Utils.clean number "[ ]" |> String.trim

let is_valid_date year month day =
  if month < 1 || month > 12 then false
  else if day < 1 then false
  else
    let days_in_month =
      match month with
      | 1 | 3 | 5 | 7 | 8 | 10 | 12 -> 31
      | 4 | 6 | 9 | 11 -> 30
      | 2 ->
          let is_leap =
            (year mod 4 = 0 && year mod 100 <> 0) || year mod 400 = 0
          in
          if is_leap then 29 else 28
      | _ -> 0
    in
    day <= days_in_month

let get_birth_date number =
  let number = compact number in
  let year = int_of_string (String.sub number 0 2) in
  let month = int_of_string (String.sub number 2 2) in
  let day = int_of_string (String.sub number 4 2) in
  let c_val = number.[6] in

  let year_full =
    if c_val = '9' then year + 1800
    else if c_val >= '0' && c_val <= '5' then year + 1900
    else year + 2000
  in

  if not (is_valid_date year_full month day) then raise Invalid_component;
  (year_full, month, day)

let get_gender number =
  let number = compact number in
  let digit = int_of_char number.[9] - int_of_char '0' in
  if digit mod 2 <> 0 then "F" else "M"

let validate number =
  let number = compact number in
  if String.length number <> 11 then raise Invalid_length;
  if not (Utils.is_digits number) then raise Invalid_format;

  ignore (get_birth_date number);

  number

let is_valid number =
  try
    ignore (validate number);
    true
  with Invalid_format | Invalid_length | Invalid_component -> false
