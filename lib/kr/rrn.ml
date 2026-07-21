(** RRN (South Korean resident registration number).

    The RRN (resident registration number, 주민등록번호) is a 13-digit number issued
    to all residents of the Republic of Korea. Foreigners residing in the
    Republic of Korea receive an alien registration number (ARN) which follows
    the same encoding pattern.

    The first six digits code the date of birth. The seventh digit encodes the
    century and gender. The next four digits encode the place of birth for
    Koreans or the issuing agency for foreigners, followed by two digits for the
    community center number, one serial number and a check digit.

    More information:
    - https://www.law.go.kr/lsSc.do?tabMenuId=tab18&p1=&subMenu=1&nwYn=1&section=&tabNo=&query=개인정보+보호법
    - https://en.wikipedia.org/wiki/Resident_registration_number
    - https://techscience.org/a/2015092901/ *)

open Tools

exception Invalid_format
exception Invalid_length
exception Invalid_component
exception Invalid_checksum

let compact number = Utils.clean number "[ -]" |> String.trim

let calc_check_digit number =
  let weights = [| 2; 3; 4; 5; 6; 7; 8; 9; 2; 3; 4; 5 |] in
  let check = ref 0 in
  for i = 0 to 11 do
    check := !check + (weights.(i) * (int_of_char number.[i] - int_of_char '0'))
  done;
  string_of_int ((11 - (!check mod 11)) mod 10)

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

let get_birth_date ?(allow_future = true) number =
  let number = compact number in
  let year_short = int_of_string (String.sub number 0 2) in
  let month = int_of_string (String.sub number 2 2) in
  let day = int_of_string (String.sub number 4 2) in
  let c = number.[6] in
  let year =
    if c = '1' || c = '2' || c = '5' || c = '6' then year_short + 1900
    else if c = '3' || c = '4' || c = '7' || c = '8' then year_short + 2000
    else year_short + 1800
  in
  if not (is_valid_date year month day) then raise Invalid_component;
  (if not allow_future then
     let open Unix in
     let current_time = time () |> localtime in
     let current_year = current_time.tm_year + 1900 in
     let current_month = current_time.tm_mon + 1 in
     let current_day = current_time.tm_mday in
     if
       year > current_year
       || (year = current_year && month > current_month)
       || (year = current_year && month = current_month && day > current_day)
     then raise Invalid_component);
  (year, month, day)

let validate ?(allow_future = true) number =
  let number = compact number in
  if not (Utils.is_digits number) then raise Invalid_format;
  if String.length number <> 13 then raise Invalid_length;
  ignore (get_birth_date ~allow_future number);
  let place_of_birth = int_of_string (String.sub number 7 2) in
  if place_of_birth > 96 then raise Invalid_component;
  if String.make 1 number.[12] <> calc_check_digit number then
    raise Invalid_checksum;
  number

let is_valid ?(allow_future = true) number =
  try
    ignore (validate ~allow_future number);
    true
  with
  | Invalid_format | Invalid_length | Invalid_component | Invalid_checksum ->
    false

let format number =
  let number = compact number in
  if String.length number = 13 then
    String.sub number 0 6 ^ "-" ^ String.sub number 6 7
  else number
