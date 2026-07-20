(** Isikukood (Estonian Personal ID number).

    The number consists of 11 digits: the first indicates the gender and century
    the person was born in, the following 6 digits the birth date, followed by a
    3 digit serial and a check digit.

    More information:
    - https://www.riigiteataja.ee/akt/106032012004 *)

open Tools

exception Invalid_format
exception Invalid_length
exception Invalid_component
exception Invalid_checksum

let compact number =
  Utils.clean number " " |> String.trim

let is_valid_date year month day =
  if month < 1 || month > 12 then false
  else if day < 1 then false
  else
    let days_in_month =
      match month with
      | 1 | 3 | 5 | 7 | 8 | 10 | 12 -> 31
      | 4 | 6 | 9 | 11 -> 30
      | 2 ->
          let is_leap = (year mod 4 = 0 && year mod 100 <> 0) || (year mod 400 = 0) in
          if is_leap then 29 else 28
      | _ -> 0
    in
    day <= days_in_month

let get_birth_date number =
  let number = compact number in
  let century =
    match number.[0] with
    | '1' | '2' -> 1800
    | '3' | '4' -> 1900
    | '5' | '6' -> 2000
    | '7' | '8' -> 2100
    | _ -> raise Invalid_component
  in
  let year_part = int_of_string (String.sub number 1 2) in
  let month = int_of_string (String.sub number 3 2) in
  let day = int_of_string (String.sub number 5 2) in
  let year = century + year_part in
  
  if not (is_valid_date year month day) then raise Invalid_component;
  (year, month, day)

let get_gender number =
  let number = compact number in
  match number.[0] with
  | '1' | '3' | '5' | '7' -> "M"
  | '2' | '4' | '6' | '8' -> "F"
  | _ -> raise Invalid_component

let calc_check_digit number =
  let len = String.length number in
  let sum1 = ref 0 in
  for i = 0 to len - 2 do
    let digit = int_of_char number.[i] - int_of_char '0' in
    let weight = (i mod 9) + 1 in
    sum1 := !sum1 + (weight * digit)
  done;
  let check1 = !sum1 mod 11 in
  let check =
    if check1 = 10 then begin
      let sum2 = ref 0 in
      for i = 0 to len - 2 do
        let digit = int_of_char number.[i] - int_of_char '0' in
        let weight = ((i + 2) mod 9) + 1 in
        sum2 := !sum2 + (weight * digit)
      done;
      !sum2 mod 11
    end else check1
  in
  string_of_int (check mod 10)

let validate number =
  let number = compact number in
  if not (Utils.is_digits number) then raise Invalid_format;
  if String.length number <> 11 then raise Invalid_length;
  
  ignore (get_birth_date number);
  
  let check_digit = calc_check_digit number in
  if String.sub number 10 1 <> check_digit then raise Invalid_checksum;
  
  number

let is_valid number =
  try
    ignore (validate number);
    true
  with Invalid_format | Invalid_length | Invalid_component | Invalid_checksum -> false
