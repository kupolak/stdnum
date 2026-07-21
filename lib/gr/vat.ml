(** FPA, ΦΠΑ, ΑΦΜ (Αριθμός Φορολογικού Μητρώου, the Greek VAT number).

    The FPA is a 9-digit number with a simple checksum. *)

open Tools

exception Invalid_format
exception Invalid_length
exception Invalid_checksum

let compact number =
  let number = Utils.clean number "[ -./:]" |> String.trim |> String.uppercase_ascii in
  let number =
    if String.starts_with ~prefix:"EL" number || String.starts_with ~prefix:"GR" number then
      String.sub number 2 (String.length number - 2)
    else number
  in
  if String.length number = 8 then "0" ^ number else number

let calc_check_digit number =
  let checksum = ref 0 in
  for i = 0 to String.length number - 1 do
    checksum := (!checksum * 2) + (int_of_char number.[i] - int_of_char '0')
  done;
  string_of_int ((!checksum * 2 mod 11) mod 10)

let validate number =
  let number = compact number in
  if not (Utils.is_digits number) then raise Invalid_format;
  if String.length number <> 9 then raise Invalid_length;
  if calc_check_digit (String.sub number 0 8) <> String.sub number 8 1 then raise Invalid_checksum;
  number

let is_valid number =
  try
    ignore (validate number);
    true
  with Invalid_format | Invalid_length | Invalid_checksum -> false
