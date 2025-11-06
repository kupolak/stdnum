open Tools

exception Invalid_format
exception Invalid_length
exception Invalid_checksum
exception Invalid_component

let compact number =
  Utils.clean number "[ -]" |> String.uppercase_ascii |> String.trim

(* Luhn algorithm for check digit validation *)
let luhn_validate number =
  if not (Utils.is_digits number) then raise Invalid_format;
  let len = String.length number in
  let sum = ref 0 in
  for i = 0 to len - 1 do
    let n = int_of_string (String.make 1 number.[len - 1 - i]) in
    let v =
      if i mod 2 = 1 then
        let d = n * 2 in
        if d > 9 then d - 9 else d
      else n
    in
    sum := !sum + v
  done;
  if !sum mod 10 <> 0 then raise Invalid_checksum

let get_birth_date number =
  let compact_number = compact number in
  if String.length compact_number <> 13 then raise Invalid_length;

  let year = int_of_string (String.sub compact_number 0 2) in
  let month = int_of_string (String.sub compact_number 2 2) in
  let day = int_of_string (String.sub compact_number 4 2) in

  (* Determine century - assume current century for future dates, previous century for past *)
  let current_year = (Unix.gmtime (Unix.time ())).Unix.tm_year + 1900 in
  let current_yy = current_year mod 100 in
  let century =
    if year > current_yy then ((current_year / 100) - 1) * 100
    else current_year / 100 * 100
  in
  let full_year = century + year in

  if month < 1 || month > 12 then raise Invalid_component;
  if day < 1 || day > 31 then raise Invalid_component;

  try
    Some
      (Unix.mktime
         {
           Unix.tm_year = full_year - 1900
         ; tm_mon = month - 1
         ; tm_mday = day
         ; tm_hour = 0
         ; tm_min = 0
         ; tm_sec = 0
         ; tm_wday = 0
         ; tm_yday = 0
         ; tm_isdst = false
         })
  with Unix.Unix_error (Unix.EINVAL, _, _) -> raise Invalid_component

let get_gender number =
  let number = compact number in
  if String.length number <> 13 then raise Invalid_length;

  let gender_digits = int_of_string (String.sub number 6 4) in
  if gender_digits < 5000 then 'F' else 'M'

let get_citizenship number =
  let number = compact number in
  if String.length number <> 13 then raise Invalid_length;

  let citizenship_digit = number.[10] in
  match citizenship_digit with
  | '0' -> "citizen"
  | '1' -> "resident"
  | _ -> raise Invalid_component

let validate number =
  let number = compact number in
  if not (Utils.is_digits number) then raise Invalid_format;
  if String.length number <> 13 then raise Invalid_length;

  (* Validate date of birth *)
  ignore (get_birth_date number);

  (* Validate citizenship digit *)
  ignore (get_citizenship number);

  (* The 11th digit (index 10) is citizenship status (0 or 1) *)
  (* The 12th digit (index 11) is usually 8 or 9, but we don't validate this strictly *)

  (* Validate checksum using Luhn algorithm *)
  luhn_validate number;

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
  if String.length number <> 13 then number
  else
    Printf.sprintf "%s %s %s %s" (String.sub number 0 6) (String.sub number 6 4)
      (String.sub number 10 2) (String.sub number 12 1)
