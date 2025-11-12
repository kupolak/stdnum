open Tools

exception Invalid_length
exception Invalid_format
exception Invalid_checksum
exception Invalid_component

let compact number =
  Utils.clean number "[ /]" |> String.uppercase_ascii |> String.trim

let is_valid_date year month day =
  (* Basic validation of date components *)
  if month < 1 || month > 12 then false
  else if day < 1 || day > 31 then false
  else
    (* More precise day validation based on month *)
    let max_day =
      match month with
      | 2 ->
          (* Leap year calculation *)
          if (year mod 4 = 0 && year mod 100 <> 0) || year mod 400 = 0 then 29
          else 28
      | 4 | 6 | 9 | 11 -> 30
      | _ -> 31
    in
    day <= max_day

let get_birth_date number =
  let number = compact number in
  let yy = int_of_string (String.sub number 0 2) in
  let mm = int_of_string (String.sub number 2 2) in
  let dd = int_of_string (String.sub number 4 2) in

  (* Start with base year *)
  let year = ref (1900 + yy) in

  (* Females have 50 added to the month value, 20 is added when the serial
     overflows (since 2004) *)
  let month = mm mod 50 mod 20 in
  let day = dd in

  (* 9 digit numbers were used until January 1st 1954 *)
  let len = String.length number in
  if len = 9 then (
    if !year >= 1980 then year := !year - 100;
    if !year > 1953 then
      raise Invalid_length (* No 9 digit birth numbers after 1953 *))
  else if !year < 1954 then year := !year + 100;

  (* Validate the date *)
  if not (is_valid_date !year month day) then raise Invalid_component;

  (!year, month, day)

let validate number =
  let number = compact number in
  if not (Utils.is_digits number) then raise Invalid_format;
  let len = String.length number in
  if len <> 9 && len <> 10 then raise Invalid_length;

  (* Check if birth date is valid *)
  ignore (get_birth_date number);

  (* Check the check digit (10 digit numbers only) *)
  (if len = 10 then
     let check = int_of_string (String.sub number 0 9) mod 11 mod 10 in
     let check_digit = String.sub number 9 1 in
     if string_of_int check <> check_digit then raise Invalid_checksum);

  number

let is_valid number =
  try
    ignore (validate number);
    true
  with
  | Invalid_format | Invalid_length | Invalid_checksum | Invalid_component ->
    false

let format number =
  let number = compact number in
  String.sub number 0 6 ^ "/" ^ String.sub number 6 (String.length number - 6)
