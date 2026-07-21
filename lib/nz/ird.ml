(** IRD number (New Zealand Inland Revenue Department (Te Tari Tāke) number).

    The IRD number is used by the New Zealand Inland Revenue Department (Te Tari
    Tāke in Māori) to identify businesses and individuals for tax purposes. The
    number consists of 8 or 9 digits where the last digit is a check digit.

    More information:
    - https://www.ird.govt.nz/
    - https://www.ird.govt.nz/-/media/Project/IR/PDF/2020RWTNRWTSpecificationDocumentv10.pdf
    - https://www.oecd.org/tax/automatic-exchange/crs-implementation-and-assistance/tax-identification-numbers/New%20Zealand-TIN.pdf
*)

open Tools

exception Invalid_format
exception Invalid_length
exception Invalid_checksum
exception Invalid_component

let compact number =
  let number =
    Utils.clean number "[ -]" |> String.trim |> String.uppercase_ascii
  in
  if String.starts_with ~prefix:"NZ" number then
    String.sub number 2 (String.length number - 2)
  else number

let calc_check_digit number =
  let primary_weights = [| 3; 2; 7; 6; 5; 4; 3; 2 |] in
  let secondary_weights = [| 7; 4; 3; 2; 5; 2; 7; 6 |] in
  let len = String.length number in
  let padded = if len < 8 then String.make (8 - len) '0' ^ number else number in
  let s1 = ref 0 in
  for i = 0 to 7 do
    s1 :=
      !s1 + (primary_weights.(i) * (int_of_char padded.[i] - int_of_char '0'))
  done;
  let s = (11 - (!s1 mod 11)) mod 11 in
  if s <> 10 then string_of_int s
  else
    let s2 = ref 0 in
    for i = 0 to 7 do
      s2 :=
        !s2
        + (secondary_weights.(i) * (int_of_char padded.[i] - int_of_char '0'))
    done;
    let s = (11 - (!s2 mod 11)) mod 11 in
    string_of_int s

let validate number =
  let number = compact number in
  let len = String.length number in
  if len <> 8 && len <> 9 then raise Invalid_length;
  if not (Utils.is_digits number) then raise Invalid_format;
  let num_val = int_of_string number in
  if num_val <= 10000000 || num_val >= 150000000 then raise Invalid_component;
  let base_part = String.sub number 0 (len - 1) in
  if String.make 1 number.[len - 1] <> calc_check_digit base_part then
    raise Invalid_checksum;
  number

let validate_result number =
  try Ok (validate number) with
  | Invalid_format -> Error Error.Invalid_format
  | Invalid_length -> Error Error.Invalid_length
  | Invalid_checksum -> Error Error.Invalid_checksum
  | Invalid_component -> Error Tools.Error.Invalid_component

let is_valid number = Result.is_ok (validate_result number)

let format number =
  let number = compact number in
  let len = String.length number in
  String.sub number 0 (len - 6)
  ^ "-"
  ^ String.sub number (len - 6) 3
  ^ "-"
  ^ String.sub number (len - 3) 3
