(** AMKA (Αριθμός Μητρώου Κοινωνικής Ασφάλισης, Greek social security number).

    The Αριθμός Μητρώου Κοινωνικής Ασφάλισης (AMKA or Arithmos Mitroou
    Koinonikis Asfalisis) is the personal identifier that is used for social
    security purposes in Greece. The number consists of 11 digits and includes
    the person's date of birth and gender.

    More information:
    - https://www.amka.gr/tieinai_en.html *)

open Tools

exception Invalid_format
exception Invalid_length
exception Invalid_checksum
exception Invalid_component

let compact number = Utils.clean number "[ -]" |> String.trim

let get_birth_date number =
  let number = compact number in
  if String.length number < 6 then raise Invalid_length;
  let day = int_of_string (String.sub number 0 2) in
  let month = int_of_string (String.sub number 2 2) in
  let year2 = int_of_string (String.sub number 4 2) in

  let is_valid_date y m d =
    if m < 1 || m > 12 then false
    else if d < 1 || d > 31 then false
    else
      let days_in_month =
        match m with
        | 4 | 6 | 9 | 11 -> 30
        | 2 ->
            let is_leap = (y mod 4 = 0 && y mod 100 <> 0) || y mod 400 = 0 in
            if is_leap then 29 else 28
        | _ -> 31
      in
      d <= days_in_month
  in

  let year = year2 + 1900 in
  if is_valid_date year month day then (year, month, day)
  else
    let year = year + 100 in
    if is_valid_date year month day then (year, month, day)
    else raise Invalid_component

let get_gender number =
  let number = compact number in
  if String.length number < 10 then raise Invalid_length;
  let g = int_of_string (String.sub number 9 1) in
  if g mod 2 = 1 then "M" else "F"

let validate number =
  let number = compact number in
  if not (Utils.is_digits number) then raise Invalid_format;
  if String.length number <> 11 then raise Invalid_length;
  if not (Luhn.is_valid number) then raise Invalid_checksum;
  ignore (get_birth_date number);
  number

let is_valid number =
  try
    ignore (validate number);
    true
  with
  | Invalid_format | Invalid_length | Invalid_checksum | Invalid_component ->
    false
