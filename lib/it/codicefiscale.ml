(** Codice Fiscale (Italian tax code for individuals).

    The Codice Fiscale is an alphanumeric code of 16 characters used to identify
    individuals residing in Italy or 11 digits for non-individuals in which case
    it matches the Imposta sul valore aggiunto.

    The 16 digit number consists of three characters derived from the person's
    last name, three from the person's first name, five that hold information on
    the person's gender and birth date, four that represent the person's place of
    birth and one check digit.

    More information:
    - https://it.m.wikipedia.org/wiki/Codice_fiscale *)

open Tools

exception Invalid_format
exception Invalid_length
exception Invalid_checksum
exception Invalid_component

(* Encoding of birth day and year values *)
let date_digits_list = "0123456789LMNPQRSTUV"

let date_digit_to_int c =
  match String.index_opt date_digits_list c with
  | Some n -> n
  | None -> raise Invalid_format

(* Encoding of month values (A = January, etc.) *)
let month_digits = "ABCDEHLMPRST"

let month_digit_to_int c =
  match String.index_opt month_digits c with
  | Some n -> n
  | None -> raise Invalid_component

(* Values of characters in even positions for checksum calculation *)
let even_value c =
  match c with
  | '0' .. '9' -> int_of_char c - int_of_char '0'
  | 'A' .. 'Z' -> int_of_char c - int_of_char 'A'
  | _ -> raise Invalid_format

(* Values of characters in odd positions for checksum calculation *)
let odd_values =
  [|
     1
   ; 0
   ; 5
   ; 7
   ; 9
   ; 13
   ; 15
   ; 17
   ; 19
   ; 21
   ; 2
   ; 4
   ; 18
   ; 20
   ; 11
   ; 3
   ; 6
   ; 8
   ; 12
   ; 14
   ; 16
   ; 10
   ; 22
   ; 25
   ; 24
   ; 23
  |]

let odd_value c =
  match c with
  | '0' .. '9' -> odd_values.(int_of_char c - int_of_char '0')
  | 'A' .. 'Z' -> odd_values.(int_of_char c - int_of_char 'A')
  | _ -> raise Invalid_format

let compact number =
  Utils.clean number "[ :\\-]" |> String.uppercase_ascii |> String.trim

let calc_check_digit number =
  let sum = ref 0 in
  for i = 0 to String.length number - 1 do
    sum :=
      !sum + if i mod 2 = 0 then odd_value number.[i] else even_value number.[i]
  done;
  let code = !sum mod 26 in
  String.make 1 (char_of_int (int_of_char 'A' + code))

let get_birth_date ?(minyear = 1920) number =
  let number = compact number in
  if String.length number <> 16 then raise Invalid_component;
  let day =
    ((date_digit_to_int number.[9] * 10) + date_digit_to_int number.[10]) mod 40
  in
  let month = month_digit_to_int number.[8] + 1 in
  let year =
    (date_digit_to_int number.[6] * 10) + date_digit_to_int number.[7]
  in
  (* Find four-digit year *)
  let year = year + (minyear / 100 * 100) in
  let year = if year < minyear then year + 100 else year in
  (* Validate the date *)
  try
    let tm =
      {
        Unix.tm_sec = 0
      ; tm_min = 0
      ; tm_hour = 12
      ; tm_mday = day
      ; tm_mon = month - 1
      ; tm_year = year - 1900
      ; tm_wday = 0
      ; tm_yday = 0
      ; tm_isdst = false
      }
    in
    let time, normalized_tm = Unix.mktime tm in
    (* Check if the date normalized correctly *)
    if
      normalized_tm.tm_mday <> day
      || normalized_tm.tm_mon <> month - 1
      || normalized_tm.tm_year <> year - 1900
    then raise Invalid_component;
    (time, normalized_tm)
  with _ -> raise Invalid_component

let get_gender number =
  let number = compact number in
  if String.length number <> 16 then raise Invalid_component;
  let day_value =
    (date_digit_to_int number.[9] * 10) + date_digit_to_int number.[10]
  in
  if day_value < 32 then "M" else "F"

let validate number =
  let number = compact number in
  if String.length number = 11 then
    (* Company number - validate as IVA *)
    try Iva.validate number with
    | Iva.Invalid_format -> raise Invalid_format
    | Iva.Invalid_length -> raise Invalid_length
    | Iva.Invalid_checksum -> raise Invalid_checksum
  else (
    if String.length number <> 16 then raise Invalid_length;
    (* Check format with regex pattern *)
    let pattern =
      Str.regexp
        "^[A-Z][A-Z][A-Z][A-Z][A-Z][A-Z][0-9LMNPQRSTUV][0-9LMNPQRSTUV][ABCDEHLMPRST][0-9LMNPQRSTUV][0-9LMNPQRSTUV][A-Z][0-9LMNPQRSTUV][0-9LMNPQRSTUV][0-9LMNPQRSTUV][A-Z]$"
    in
    if not (Str.string_match pattern number 0) then raise Invalid_format;
    (* Check check digit *)
    if calc_check_digit (String.sub number 0 15) <> String.make 1 number.[15]
    then raise Invalid_checksum;
    (* Validate birth date *)
    ignore (get_birth_date number);
    number)

let is_valid number =
  try
    ignore (validate number);
    true
  with
  | Invalid_format | Invalid_length | Invalid_checksum | Invalid_component ->
      false
  | Iva.Invalid_format | Iva.Invalid_length | Iva.Invalid_checksum -> false
