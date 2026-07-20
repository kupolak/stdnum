(** CPR (personnummer, the Danish citizen number).

    The CPR is the national number to identify Danish citizens and is stored in
    the Det Centrale Personregister (Civil Registration System). The number
    consists of 10 digits in the format DDMMYY-SSSS where the first part
    represents the birth date and the second a sequence number. The first digit
    of the sequence number indicates the century.

    More information:
    - https://en.wikipedia.org/wiki/Personal_identification_number_(Denmark)
    - https://da.wikipedia.org/wiki/CPR-nummer
    - https://cpr.dk/ *)

open Tools

exception Invalid_format
exception Invalid_length
exception Invalid_component

let compact number =
  Utils.clean number "[ -]" |> String.trim

let checksum number =
  let weights = [| 4; 3; 2; 7; 6; 5; 4; 3; 2; 1 |] in
  let sum = ref 0 in
  for i = 0 to 9 do
    let digit = int_of_char number.[i] - int_of_char '0' in
    sum := !sum + (weights.(i) * digit)
  done;
  !sum mod 11

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
  let day = int_of_string (String.sub number 0 2) in
  let month = int_of_string (String.sub number 2 2) in
  let year = int_of_string (String.sub number 4 2) in
  let seq_first = number.[6] in
  
  let year_full =
    if (seq_first = '5' || seq_first = '6' || seq_first = '7' || seq_first = '8') && year >= 58 then
      year + 1800
    else if (seq_first >= '0' && seq_first <= '3') || ((seq_first = '4' || seq_first = '9') && year >= 37) then
      year + 1900
    else
      year + 2000
  in
  
  if not (is_valid_date year_full month day) then raise Invalid_component;
  (year_full, month, day)

let compare_dates (y1, m1, d1) (y2, m2, d2) =
  if y1 <> y2 then compare y1 y2
  else if m1 <> m2 then compare m1 m2
  else compare d1 d2

let validate number =
  let number = compact number in
  if not (Utils.is_digits number) then raise Invalid_format;
  if String.length number <> 10 then raise Invalid_length;
  
  let birth_date = get_birth_date number in
  let tm = Unix.localtime (Unix.time ()) in
  let current_date = (tm.Unix.tm_year + 1900, tm.Unix.tm_mon + 1, tm.Unix.tm_mday) in
  
  if compare_dates birth_date current_date > 0 then
    raise Invalid_component;
    
  number

let is_valid number =
  try
    ignore (validate number);
    true
  with Invalid_format | Invalid_length | Invalid_component -> false

let format number =
  let number = compact number in
  String.sub number 0 6 ^ "-" ^ String.sub number 6 4
