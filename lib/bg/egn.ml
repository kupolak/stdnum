(** EGN (ЕГН, Единен граждански номер, Bulgarian personal identity codes).

    It is a 10-digit number of which the first 6 digits denote the person's
    birth date, the next three digits represent a birth order number from which
    the person's gender can be determined and the last digit is a check digit.

    More information:
    - https://en.wikipedia.org/wiki/Uniform_civil_number *)

open Tools

exception Invalid_format
exception Invalid_length
exception Invalid_component
exception Invalid_checksum

let compact number =
  Utils.clean number "[ -.]" |> String.trim |> String.uppercase_ascii

let calc_check_digit number =
  let weights = [| 2; 4; 8; 5; 10; 9; 7; 3; 6 |] in
  let sum = ref 0 in
  for i = 0 to 8 do
    let digit = int_of_char number.[i] - int_of_char '0' in
    sum := !sum + (weights.(i) * digit)
  done;
  string_of_int (!sum mod 11 mod 10)

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
  let year = int_of_string (String.sub number 0 2) + 1900 in
  let month = int_of_string (String.sub number 2 2) in
  let day = int_of_string (String.sub number 4 2) in

  let y, m =
    if month > 40 then (year + 100, month - 40)
    else if month > 20 then (year - 100, month - 20)
    else (year, month)
  in

  if not (is_valid_date y m day) then raise Invalid_component;
  (y, m, day)

let validate number =
  let number = compact number in
  if not (Utils.is_digits number) then raise Invalid_format;
  if String.length number <> 10 then raise Invalid_length;

  ignore (get_birth_date number);

  if calc_check_digit (String.sub number 0 9) <> String.sub number 9 1 then
    raise Invalid_checksum;

  number

let is_valid number =
  try
    ignore (validate number);
    true
  with
  | Invalid_format | Invalid_length | Invalid_component | Invalid_checksum ->
    false
