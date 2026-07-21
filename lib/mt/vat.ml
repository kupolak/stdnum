(** VAT (Maltese VAT number).

    The Maltese VAT registration number contains 8 digits and uses a simple
    weigted checksum. *)

open Tools

exception Invalid_format
exception Invalid_length
exception Invalid_checksum

let compact number =
  let number =
    Utils.clean number "[ -]" |> String.trim |> String.uppercase_ascii
  in
  if String.starts_with ~prefix:"MT" number then
    String.sub number 2 (String.length number - 2)
  else number

let checksum number =
  let weights = [| 3; 4; 6; 7; 8; 9; 10; 1 |] in
  let check = ref 0 in
  for i = 0 to 7 do
    check := !check + (weights.(i) * (int_of_char number.[i] - int_of_char '0'))
  done;
  !check mod 37

let validate number =
  let number = compact number in
  if
    (not (Utils.is_digits number))
    || (String.length number > 0 && number.[0] = '0')
  then raise Invalid_format;
  if String.length number <> 8 then raise Invalid_length;
  if checksum number <> 0 then raise Invalid_checksum;
  number

let is_valid number =
  try
    ignore (validate number);
    true
  with Invalid_format | Invalid_length | Invalid_checksum -> false
