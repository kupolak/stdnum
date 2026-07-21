(** NRIC No. (Malaysian National Registration Identity Card Number).

    The NRIC No. is the unique identifier for issued to Malaysian citizens and
    permanent residents.

    The number consist of 12 digits in three sections. The first 6 digits
    represent the birth date, followed by two digits representing the birth
    place and finally four digits. The gender of a person can be derived from
    the last digit: odd numbers for males and even numbers for females. *)

open Tools

exception Invalid_format
exception Invalid_length
exception Invalid_component

let compact number = Utils.clean number "[-* ]" |> String.trim

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
  let year = int_of_string (String.sub number 0 2) in
  let month = int_of_string (String.sub number 2 2) in
  let day = int_of_string (String.sub number 4 2) in
  if is_valid_date (year + 1900) month day then (year + 1900, month, day)
  else if is_valid_date (year + 2000) month day then (year + 2000, month, day)
  else raise Invalid_component

let get_birth_place number =
  let number = compact number in
  let bp_code = String.sub number 6 2 in
  let valid_bps =
    [
      "01"
    ; "02"
    ; "03"
    ; "04"
    ; "05"
    ; "06"
    ; "07"
    ; "08"
    ; "09"
    ; "10"
    ; "11"
    ; "12"
    ; "13"
    ; "14"
    ; "15"
    ; "16"
    ; "21"
    ; "22"
    ; "23"
    ; "24"
    ; "25"
    ; "26"
    ; "27"
    ; "28"
    ; "29"
    ; "30"
    ; "31"
    ; "32"
    ; "33"
    ; "34"
    ; "35"
    ; "36"
    ; "37"
    ; "38"
    ; "39"
    ; "40"
    ; "41"
    ; "42"
    ; "43"
    ; "44"
    ; "45"
    ; "46"
    ; "47"
    ; "48"
    ; "49"
    ; "50"
    ; "51"
    ; "52"
    ; "53"
    ; "54"
    ; "55"
    ; "56"
    ; "57"
    ; "58"
    ; "59"
    ; "60"
    ; "61"
    ; "62"
    ; "63"
    ; "64"
    ; "65"
    ; "66"
    ; "67"
    ; "68"
    ; "71"
    ; "72"
    ; "74"
    ; "75"
    ; "76"
    ; "77"
    ; "78"
    ; "79"
    ; "82"
    ; "83"
    ; "84"
    ; "85"
    ; "86"
    ; "87"
    ; "88"
    ; "89"
    ; "90"
    ; "91"
    ; "92"
    ; "93"
    ; "98"
    ; "99"
    ]
  in
  if not (List.mem bp_code valid_bps) then raise Invalid_component;
  bp_code

let validate number =
  let number = compact number in
  if String.length number <> 12 then raise Invalid_length;
  if not (Utils.is_digits number) then raise Invalid_format;
  ignore (get_birth_date number);
  ignore (get_birth_place number);
  number

let is_valid number =
  try
    ignore (validate number);
    true
  with Invalid_format | Invalid_length | Invalid_component -> false

let format number =
  let number = compact number in
  String.sub number 0 6 ^ "-" ^ String.sub number 6 2 ^ "-"
  ^ String.sub number 8 4
