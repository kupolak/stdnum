(** Euro banknote serial numbers.

    The serial number consists of one letter and 11 digits, or two letters and
    10 digits for the new series banknotes.

    More information:
    - https://en.wikipedia.org/wiki/Euro_banknotes#Serial_number *)

open Tools

exception Invalid_format
exception Invalid_length
exception Invalid_component
exception Invalid_checksum

let compact number =
  Utils.clean number " " |> String.trim |> String.uppercase_ascii

let checksum number =
  let sum = ref 0 in
  String.iter
    (fun x ->
      if x >= '0' && x <= '9' then
        sum := !sum + (int_of_char x - int_of_char '0')
      else sum := !sum + int_of_char x)
    number;
  !sum mod 9

let is_valid_char c =
  let valid_chars = "BCDEFGHJLMNPRSTUVWXYZ" in
  String.contains valid_chars c

let validate number =
  let number = compact number in
  let len = String.length number in
  if len <> 12 then raise Invalid_length;

  if
    (not (Utils.is_alnum (String.sub number 0 2)))
    || not (Utils.is_digits (String.sub number 2 10))
  then raise Invalid_format;

  if not (is_valid_char number.[0]) then raise Invalid_component;

  if checksum number <> 0 then raise Invalid_checksum;

  number

let validate_result number =
  try Ok (validate number) with
  | Invalid_format -> Error Error.Invalid_format
  | Invalid_length -> Error Error.Invalid_length
  | Invalid_component -> Error Tools.Error.Invalid_component
  | Invalid_checksum -> Error Error.Invalid_checksum

let is_valid number = Result.is_ok (validate_result number)
