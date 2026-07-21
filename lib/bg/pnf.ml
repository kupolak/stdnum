(** PNF (ЛНЧ, Личен номер на чужденец, Bulgarian number of a foreigner).

    The personal number of a foreigner is a 10-digit number where the last digit
    is the result of a weighted checksum. *)

open Tools

exception Invalid_format
exception Invalid_length
exception Invalid_checksum

let compact number =
  Utils.clean number "[ -.]" |> String.trim |> String.uppercase_ascii

let calc_check_digit number =
  let weights = [| 21; 19; 17; 13; 11; 9; 7; 3; 1 |] in
  let sum = ref 0 in
  for i = 0 to 8 do
    let digit = int_of_char number.[i] - int_of_char '0' in
    sum := !sum + (weights.(i) * digit)
  done;
  string_of_int (!sum mod 10)

let validate number =
  let number = compact number in
  if not (Utils.is_digits number) then raise Invalid_format;
  if String.length number <> 10 then raise Invalid_length;

  if calc_check_digit (String.sub number 0 9) <> String.sub number 9 1 then
    raise Invalid_checksum;

  number

let is_valid number =
  try
    ignore (validate number);
    true
  with Invalid_format | Invalid_length | Invalid_checksum -> false
