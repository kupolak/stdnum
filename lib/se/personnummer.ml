open Tools

exception Invalid_length
exception Invalid_format
exception Invalid_checksum
exception Invalid_component

let compact number =
  let number = Utils.clean number "[ :]" in
  let len = String.length number in
  if
    (len = 10 || len = 12) && number.[len - 5] <> '-' && number.[len - 5] <> '+'
  then
    let before_sep = String.sub number 0 (len - 4) in
    let after_sep = String.sub number (len - 4) 4 in
    before_sep ^ "-" ^ after_sep
  else
    let before_sep = String.sub number 0 (len - 5) in
    let sep = String.make 1 number.[len - 5] in
    let after_sep = String.sub number (len - 4) 4 in
    let cleaned_before = Utils.clean before_sep "[-+]" in
    cleaned_before ^ sep ^ after_sep

let get_birth_date number =
  let number = compact number in
  let len = String.length number in
  let year, month, day =
    if len = 13 then
      let year = int_of_string (String.sub number 0 4) in
      let month = int_of_string (String.sub number 4 2) in
      let day = int_of_string (String.sub number 6 2) in
      (year, month, day)
    else
      (* len = 11 *)
      let now = Unix.time () in
      let tm = Unix.localtime now in
      let current_year = tm.Unix.tm_year + 1900 in
      let century = current_year / 100 in
      let yy = int_of_string (String.sub number 0 2) in
      let century =
        if yy > current_year mod 100 then century - 1
        else if number.[len - 5] = '+' then century - 1
        else century
      in
      let year = (century * 100) + yy in
      let month = int_of_string (String.sub number 2 2) in
      let day = int_of_string (String.sub number 4 2) in
      (year, month, day)
  in
  try
    Some
      (Unix.mktime
         {
           Unix.tm_year = year - 1900
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
  let len = String.length number in
  let gender_digit = int_of_char number.[len - 2] - int_of_char '0' in
  if gender_digit mod 2 = 1 then 'M' else 'F'

let validate number =
  let number = compact number in
  let len = String.length number in
  if len <> 11 && len <> 13 then raise Invalid_length;
  let sep_pos = len - 5 in
  if number.[sep_pos] <> '-' && number.[sep_pos] <> '+' then
    raise Invalid_format;
  let digits_before = String.sub number 0 sep_pos in
  let digits_after = String.sub number (sep_pos + 1) 4 in
  let all_digits = digits_before ^ digits_after in
  if not (Utils.is_digits all_digits) then raise Invalid_format;
  ignore (get_birth_date number);
  (* Validate Luhn checksum on last 10 digits *)
  let check_digits = String.sub all_digits (String.length all_digits - 10) 10 in
  if Luhn.checksum check_digits <> 0 then raise Invalid_checksum;
  number

let is_valid number =
  try
    ignore (validate number);
    true
  with
  | Invalid_format | Invalid_length | Invalid_checksum | Invalid_component ->
    false

let format number = compact number
