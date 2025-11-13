(** Fødselsnummer (Norwegian birth number, the national identity number).

    The Fødselsnummer is an eleven-digit number that is built up of the date of
    birth of the person, a serial number and two check digits.

    More information:
    - https://no.wikipedia.org/wiki/F%C3%B8dselsnummer
    - https://en.wikipedia.org/wiki/National_identification_number#Norway *)

open Tools

exception Invalid_component
exception Invalid_length
exception Invalid_checksum
exception Invalid_format

let compact number =
  Utils.clean number "[ :\\-]" |> String.uppercase_ascii |> String.trim

let calc_check_digit1 number =
  let weights = [ 3; 7; 6; 1; 8; 9; 4; 5; 2 ] in
  let number_list =
    List.map (fun x -> int_of_char x - 48) (List.of_seq (String.to_seq number))
  in
  let sum =
    List.fold_left2 (fun acc w n -> acc + (w * n)) 0 weights number_list
  in
  string_of_int ((11 - (sum mod 11)) mod 11)

let calc_check_digit2 number =
  let weights = [ 5; 4; 3; 2; 7; 6; 5; 4; 3; 2 ] in
  let number_list =
    List.map (fun x -> int_of_char x - 48) (List.of_seq (String.to_seq number))
  in
  let sum =
    List.fold_left2 (fun acc w n -> acc + (w * n)) 0 weights number_list
  in
  string_of_int ((11 - (sum mod 11)) mod 11)

let get_gender number =
  let number = compact number in
  if int_of_char number.[8] mod 2 = 1 then 'M' else 'F'

let get_birth_date number =
  let compact_number = compact number in
  let day = int_of_string (String.sub compact_number 0 2) in
  let month = int_of_string (String.sub compact_number 2 2) in
  let year = int_of_string (String.sub compact_number 4 2) in
  let individual_digits = int_of_string (String.sub compact_number 6 3) in

  (* Raise a more useful exception for FH numbers *)
  if day >= 80 then
    raise
      (Invalid_argument
         "This number is an FH-number, and does not contain birth date \
          information by design.");

  (* Correct the birth day for D-numbers. These have a modified first digit.
     https://no.wikipedia.org/wiki/F%C3%B8dselsnummer#D-nummer *)
  let day = if day > 40 then day - 40 else day in

  (* Correct the birth month for H-numbers. These have a modified third digit.
     https://no.wikipedia.org/wiki/F%C3%B8dselsnummer#H-nummer *)
  let month = if month > 40 then month - 40 else month in

  (* Determine the full year based on individual digits and year *)
  let year =
    if individual_digits < 500 then year + 1900
    else if individual_digits < 750 && year >= 54 then year + 1800
    else if individual_digits < 1000 && year < 40 then year + 2000
    else if individual_digits >= 900 && individual_digits < 1000 && year >= 40
    then year + 1900
    else
      (* The birth century falls outside all defined ranges. *)
      raise Invalid_component
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
  with Unix.Unix_error (Unix.EINVAL, _, _) ->
    raise
      (Invalid_argument
         "The number does not contain valid birth date information.")

let validate number =
  let number = compact number in
  if String.length number <> 11 then raise Invalid_length;
  if not (Utils.is_digits number) then raise Invalid_format;
  if String.make 1 number.[9] <> calc_check_digit1 (String.sub number 0 9) then
    raise Invalid_checksum;
  if String.make 1 number.[10] <> calc_check_digit2 (String.sub number 0 10)
  then raise Invalid_checksum;
  (* Validate birth date *)
  (match get_birth_date number with
  | Some (birth_time, _) ->
      let today = Unix.time () in
      if birth_time > today then
        raise
          (Invalid_argument
             "The birth date information is valid, but this person has not \
              been born yet.")
  | None -> raise Invalid_component);
  number

let is_valid number =
  try
    ignore (validate number);
    true
  with
  | Invalid_format | Invalid_length | Invalid_checksum | Invalid_component
  | Invalid_argument _
  ->
    false

let format number =
  let number = compact number in
  if String.length number <> 11 then number
  else String.sub number 0 6 ^ " " ^ String.sub number 6 5
