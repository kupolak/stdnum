(** RFC (Registro Federal de Contribuyentes, Mexican tax number).

    This number is used to identify individuals and companies for tax purposes.

    The company number is 12 digits where the first 3 letters or digits are
    derived from the name of the company, the following 6 contain the date of
    incorporation, followed by 3 check digits.

    Personal numbers consist of 13 digits where the first 4 characters from the
    person's name, followed by their birth date and 3 check digits.

    The first two check digits are calculated based on the person's or company's
    full name. The last check digit is calculated over all the preceding digits
    in the number. However, it seems a lot of numbers (estimated at around 1.5%
    of all numbers) are in use with invalid check digits so this test is disabled
    by default.

    More information:
    - https://www.infomex.org.mx/jspsi/documentos/2005/seguimiento/06101/0610100162005_065.doc
    - https://es.wikipedia.org/wiki/Registro_Federal_de_Contribuyentes_(M%C3%A9xico) *)

open Tools

exception Invalid_format
exception Invalid_length
exception Invalid_checksum
exception Invalid_component

let name_blacklist =
  [ "BUEI"; "BUEY"; "CACA"; "CACO"; "CAGA"; "CAGO"; "CAKA"; "CAKO"; "COGE"
  ; "COJA"; "COJE"; "COJI"; "COJO"; "CULO"; "FETO"; "GUEY"; "JOTO"; "KACA"
  ; "KACO"; "KAGA"; "KAGO"; "KAKA"; "KOGE"; "KOJO"; "KULO"; "MAME"; "MAMO"
  ; "MEAR"; "MEAS"; "MEON"; "MION"; "MOCO"; "MULA"; "PEDA"; "PEDO"; "PENE"
  ; "PUTA"; "PUTO"; "QULO"; "RATA"; "RUIN" ]

let compact number =
  Utils.clean number "[-_ ]" |> String.trim |> String.uppercase_ascii

let is_valid_date year month day =
  if year < 1 || month < 1 || month > 12 || day < 1 || day > 31 then false
  else
    let days_in_month =
      match month with
      | 4 | 6 | 9 | 11 -> 30
      | 2 ->
          let is_leap = (year mod 4 = 0 && year mod 100 <> 0) || (year mod 400 = 0) in
          if is_leap then 29 else 28
      | _ -> 31
    in
    day <= days_in_month

let get_date number =
  let year = int_of_string (String.sub number 0 2) in
  let month = int_of_string (String.sub number 2 2) in
  let day = int_of_string (String.sub number 4 2) in
  if not (is_valid_date (year + 2000) month day) then raise Invalid_component;
  (year + 2000, month, day)

let alphabet = [|
  "0"; "1"; "2"; "3"; "4"; "5"; "6"; "7"; "8"; "9";
  "A"; "B"; "C"; "D"; "E"; "F"; "G"; "H"; "I"; "J";
  "K"; "L"; "M"; "N"; "&"; "O"; "P"; "Q"; "R"; "S";
  "T"; "U"; "V"; "W"; "X"; "Y"; "Z"; " "; "\195\145" (* Ñ *)
|]

let get_char_index c_str =
  let rec find idx =
    if idx >= Array.length alphabet then 0
    else if alphabet.(idx) = c_str then idx
    else find (idx + 1)
  in find 0

(* Convert string possibly containing multi-byte characters into array of single-char strings *)
let explode_utf8 s =
  let rec aux i acc =
    if i >= String.length s then List.rev acc
    else if Char.code s.[i] < 128 then
      aux (i + 1) (String.make 1 s.[i] :: acc)
    else if i + 1 < String.length s then
      aux (i + 2) (String.sub s i 2 :: acc)
    else acc (* Should not happen for valid UTF-8, but just in case *)
  in
  aux 0 [] |> Array.of_list

let calc_check_digit number =
  (* padding with spaces if needed, but Python does: ('   ' + number)[-12:] *)
  (* Let's just explode to an array, then pad it *)
  let chars = explode_utf8 number in
  let padded =
    let len = Array.length chars in
    if len >= 12 then Array.sub chars (len - 12) 12
    else
      let res = Array.make 12 " " in
      Array.blit chars 0 res (12 - len) len;
      res
  in
  let check = ref 0 in
  for i = 0 to 11 do
    check := !check + (get_char_index padded.(i) * (13 - i))
  done;
  alphabet.((11 - (!check mod 11)) mod 11)

let validate ?(validate_check_digits = false) number =
  let number = compact number in
  let len =
    let rec utf8_len s i count =
      if i >= String.length s then count
      else if Char.code s.[i] < 128 then utf8_len s (i + 1) (count + 1)
      else utf8_len s (i + 2) (count + 1)
    in
    utf8_len number 0 0
  in
  if len = 10 || len = 13 then (
    let re = Str.regexp "^[A-Z&\195\145][A-Z&\195\145][A-Z&\195\145][A-Z&\195\145][0-9][0-9][0-9][0-9][0-9][0-9]\\([0-9A-Z][0-9A-Z]?[0-9A-Z]?\\)?$" in
    if not (Str.string_match re number 0) then raise Invalid_format;
    (* Need to extract the first 4 utf-8 characters to check against blacklist *)
    let chars = explode_utf8 number in
    let first4 = String.concat "" (Array.to_list (Array.sub chars 0 4)) in
    if List.mem first4 name_blacklist then raise Invalid_component;
    let date_part = String.concat "" (Array.to_list (Array.sub chars 4 6)) in
    ignore (get_date date_part)
  ) else if len = 12 then (
    let re = Str.regexp "^[A-Z&\195\145][A-Z&\195\145][A-Z&\195\145][0-9][0-9][0-9][0-9][0-9][0-9][0-9A-Z][0-9A-Z][0-9A-Z]$" in
    if not (Str.string_match re number 0) then raise Invalid_format;
    let chars = explode_utf8 number in
    let date_part = String.concat "" (Array.to_list (Array.sub chars 3 6)) in
    ignore (get_date date_part)
  ) else raise Invalid_length;

  if validate_check_digits && len >= 12 then (
    let chars = explode_utf8 number in
    let last3 = String.concat "" (Array.to_list (Array.sub chars (len - 3) 3)) in
    let re2 = Str.regexp "^[1-9A-V][1-9A-Z][0-9A]$" in
    if not (Str.string_match re2 last3 0) then raise Invalid_component;
    let base_part = String.concat "" (Array.to_list (Array.sub chars 0 (len - 1))) in
    let last_char = chars.(len - 1) in
    if last_char <> calc_check_digit base_part then raise Invalid_checksum
  );
  number

let is_valid ?(validate_check_digits = false) number =
  try
    ignore (validate ~validate_check_digits number);
    true
  with Invalid_format | Invalid_length | Invalid_checksum | Invalid_component -> false

let format ?(separator = " ") number =
  let number = compact number in
  let chars = explode_utf8 number in
  let len = Array.length chars in
  if len = 12 then
    let p1 = String.concat "" (Array.to_list (Array.sub chars 0 3)) in
    let p2 = String.concat "" (Array.to_list (Array.sub chars 3 6)) in
    let p3 = String.concat "" (Array.to_list (Array.sub chars 9 3)) in
    p1 ^ separator ^ p2 ^ separator ^ p3
  else
    let p1 = String.concat "" (Array.to_list (Array.sub chars 0 4)) in
    let p2 = String.concat "" (Array.to_list (Array.sub chars 4 6)) in
    let p3 = String.concat "" (Array.to_list (Array.sub chars 10 (len - 10))) in
    if p3 = "" then p1 ^ separator ^ p2 else p1 ^ separator ^ p2 ^ separator ^ p3
