open Tools

exception Invalid_length
exception Invalid_format
exception Invalid_checksum
exception Invalid_component of string

let compact number = Utils.clean number "[ -.]" |> String.trim

let checksum number =
  (* Calculate the checksum and return the detected century *)
  let current_year =
    let time = Unix.time () in
    let tm = Unix.gmtime time in
    1900 + tm.Unix.tm_year
  in

  let base_num = String.sub number 0 9 in
  let check_digits = String.sub number 9 2 in
  let check = int_of_string check_digits in

  (* Try 1900s *)
  let num_1900 = int_of_string base_num in
  if 97 - (num_1900 mod 97) = check then 1900
    (* Try 2000s if birth year is plausible *)
  else if int_of_string (String.sub number 0 2) + 2000 <= current_year then
    let num_2000 = int_of_string ("2" ^ base_num) in
    if 97 - (num_2000 mod 97) = check then 2000 else raise Invalid_checksum
  else raise Invalid_checksum

let get_birth_date_parts number =
  (* Check if the number's encoded birth date is valid, and return the contained
     birth year, month and day of month, accounting for unknown values *)
  let century = checksum number in

  (* If the fictitious dates 1900/00/01 or 2000/00/01 are detected,
     the birth date (including the year) was not known when the number was issued *)
  let first_six = String.sub number 0 6 in
  if first_six = "000001" || first_six = "002001" || first_six = "004001" then
    (None, None, None)
  else
    let year = int_of_string (String.sub number 0 2) + century in
    let month = int_of_string (String.sub number 2 2) mod 20 in
    let day = int_of_string (String.sub number 4 2) in

    (* When the month is zero, it was either unknown when the number was issued,
       or the day counter ran out *)
    if month = 0 then (Some year, None, None)
    else if month > 12 then raise (Invalid_component "Month must be in 1..12")
    else if day = 0 then (Some year, Some month, None)
    else
      (* Verify day is valid for the month *)
      let max_day =
        match month with
        | 2 ->
            (* Check for leap year *)
            if (year mod 4 = 0 && year mod 100 <> 0) || year mod 400 = 0 then 29
            else 28
        | 4 | 6 | 9 | 11 -> 30
        | _ -> 31
      in
      if day > max_day then (Some year, Some month, None)
      else (Some year, Some month, Some day)

let validate number =
  let number = compact number in
  if (not (Utils.is_digits number)) || int_of_string number <= 0 then
    raise Invalid_format;
  if String.length number <> 11 then raise Invalid_length;

  let _ = get_birth_date_parts number in

  (* Additional validation: month must be in valid range *)
  let month = int_of_string (String.sub number 2 2) in
  if month < 0 || month > 12 then
    raise (Invalid_component "Month must be in 1..12");

  number

let is_valid number =
  try
    ignore (validate number);
    true
  with
  | Invalid_format | Invalid_length | Invalid_checksum | Invalid_component _ ->
    false

let format number =
  let number = compact number in
  Printf.sprintf "%s.%s.%s-%s.%s" (String.sub number 0 2)
    (String.sub number 2 2) (String.sub number 4 2) (String.sub number 6 3)
    (String.sub number 9 2)

let get_birth_year number =
  let year, _, _ = get_birth_date_parts (compact number) in
  year

let get_birth_month number =
  let _, month, _ = get_birth_date_parts (compact number) in
  month

let get_birth_date number =
  let year, month, day = get_birth_date_parts (compact number) in
  match (year, month, day) with
  | Some y, Some m, Some d -> Some (y, m, d)
  | _ -> None

let get_gender number =
  let number = compact number in
  let counter = int_of_string (String.sub number 6 3) in
  if counter mod 2 = 1 then "M" else "F"
