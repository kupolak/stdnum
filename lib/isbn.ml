(** ISBN (International Standard Book Number).

    The ISBN is the International Standard Book Number, used to identify
    publications. An ISBN is used to identify books. Numbers can either have 10
    digits (in ISBN-10 format) or 13 digits (in ISBN-13, EAN compatible format).

    More information:
    - https://en.wikipedia.org/wiki/International_Standard_Book_Number
    - https://www.isbn-international.org/range_file_generation *)

open Tools

exception Invalid_format
exception Invalid_length
exception Invalid_checksum
exception Invalid_component

let calc_isbn10_check_digit number =
  let check = ref 0 in
  for i = 0 to 8 do
    check := !check + ((i + 1) * (int_of_char number.[i] - int_of_char '0'))
  done;
  let res = !check mod 11 in
  if res = 10 then "X" else string_of_int res

let rec compact ?(convert = false) number =
  let number =
    Utils.clean number "[ -]" |> String.trim |> String.uppercase_ascii
  in
  let number = if String.length number = 9 then "0" ^ number else number in
  if convert then to_isbn13 number else number

and to_isbn13 number =
  let number = String.trim number in
  let min_number = Utils.clean number "[ -]" in
  if String.length min_number = 13 then number
  else
    let min_number =
      if String.length min_number = 9 then "0" ^ min_number else min_number
    in
    let new_check = Ean.calc_check_digit ("978" ^ String.sub min_number 0 9) in
    let base_part = String.sub number 0 (String.length number - 1) in
    if String.contains number ' ' then "978 " ^ base_part ^ new_check
    else if String.contains number '-' then "978-" ^ base_part ^ new_check
    else "978" ^ base_part ^ new_check

let validate ?(convert = false) number =
  let compact_num = compact ~convert:false number in
  if
    not
      (Utils.is_digits
         (String.sub compact_num 0 (String.length compact_num - 1)))
  then raise Invalid_format;
  if String.length compact_num = 10 then (
    let check = calc_isbn10_check_digit (String.sub compact_num 0 9) in
    if String.make 1 compact_num.[9] <> check then raise Invalid_checksum)
  else if String.length compact_num = 13 then (
    let () =
      try ignore (Ean.validate compact_num) with
      | Ean.Invalid_format -> raise Invalid_format
      | Ean.Invalid_length -> raise Invalid_length
      | Ean.Invalid_checksum -> raise Invalid_checksum
    in
    let prefix = String.sub compact_num 0 3 in
    if prefix <> "978" && prefix <> "979" then raise Invalid_component)
  else raise Invalid_length;
  if convert then to_isbn13 compact_num else compact_num

let validate_result number =
  try Ok (validate number) with
  | Invalid_format -> Error Error.Invalid_format
  | Invalid_length -> Error Error.Invalid_length
  | Invalid_checksum -> Error Error.Invalid_checksum
  | Invalid_component -> Error Tools.Error.Invalid_component

let isbn_type number =
  try
    let valid_num = validate ~convert:false number in
    if String.length valid_num = 10 then Some "ISBN10" else Some "ISBN13"
  with
  | Invalid_format | Invalid_length | Invalid_checksum | Invalid_component ->
    None

let is_valid number =
  match isbn_type number with Some _ -> true | None -> false

let to_isbn10 number =
  let number = String.trim number in
  let min_number = compact ~convert:false number in
  if String.length min_number = 10 then number
  else if isbn_type min_number <> Some "ISBN13" then raise Invalid_format
  else if not (String.starts_with ~prefix:"978" min_number) then
    raise Invalid_component
  else
    let clean_base = String.sub min_number 3 9 in
    let check_digit = calc_isbn10_check_digit clean_base in
    let base_part = String.sub number 3 (String.length number - 4) in
    let base_part = String.trim base_part in
    let base_part =
      if String.starts_with ~prefix:"-" base_part then
        String.sub base_part 1 (String.length base_part - 1)
      else base_part
    in
    let base_part =
      if String.ends_with ~suffix:"-" base_part then
        String.sub base_part 0 (String.length base_part - 1)
      else base_part
    in
    let base_part = String.trim base_part in
    if String.contains number ' ' then base_part ^ " " ^ check_digit
    else if String.contains number '-' then base_part ^ "-" ^ check_digit
    else base_part ^ check_digit
