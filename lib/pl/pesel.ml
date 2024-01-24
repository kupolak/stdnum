open Tools

exception Invalid_component
exception Invalid_length
exception Invalid_checksum
exception Invalid_format

let compact number =
  let cleaned_number =
    Utils.clean number "-" |> String.uppercase_ascii |> String.trim
  in
  if String.sub cleaned_number 0 2 = "PL" then
    String.sub cleaned_number 2 (String.length cleaned_number - 2)
  else cleaned_number

let get_birth_date number =
  let compact_number = compact number in
  let get_substring start = int_of_string (String.sub compact_number start 2) in
  let year = get_substring 0 in
  let month = get_substring 2 in
  let day = get_substring 4 in
  let year =
    year
    +
    match month / 20 with
    | 0 -> 1900
    | 1 -> 2000
    | 2 -> 2100
    | 3 -> 2200
    | 4 -> 1800
    | _ -> raise Invalid_component
  in
  let month = month mod 20 in
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
  with Unix.Unix_error (Unix.EINVAL, _, _) -> None

let get_gender number =
  let number = compact number in
  if int_of_char number.[10] mod 2 = 0 then 'F' else 'M'

let calc_check_digit number =
  let weights = [ 1; 3; 7; 9; 1; 3; 7; 9; 1; 3 ] in
  let number_list =
    List.map (fun x -> int_of_char x - 48) (List.of_seq (String.to_seq number))
  in
  let check =
    List.fold_left2 (fun acc w n -> acc + (w * n)) 0 weights number_list
  in
  string_of_int ((10 - (check mod 10)) mod 10)

let validate number =
  let number = compact number in
  if not (Utils.is_digits number) then raise Invalid_format
  else if String.length number <> 11 then raise Invalid_length
  else if String.make 1 number.[10] <> calc_check_digit (String.sub number 0 10)
  then raise Invalid_checksum
  else ignore (get_birth_date number);
  number

let is_valid number =
  try
    ignore (validate number);
    true
  with
  | Invalid_format | Invalid_length | Invalid_checksum | Invalid_component ->
    false
