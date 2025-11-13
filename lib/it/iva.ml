(** IVA (Imposta sul Valore Aggiunto, Italian VAT number).

    The IVA is an 11-digit number used to identify businesses in Italy.
    It consists of 10 digits followed by a check digit.

    This is a minimal implementation for use by codicefiscale module. *)

open Tools

exception Invalid_format
exception Invalid_length
exception Invalid_checksum

let compact number = Utils.clean number "[ :\\-]" |> String.trim

let calc_check_digit number =
  let sum = ref 0 in
  for i = 0 to 9 do
    let digit = int_of_char number.[i] - int_of_char '0' in
    let value = if i mod 2 = 0 then digit else digit * 2 in
    sum := !sum + (value / 10) + (value mod 10)
  done;
  string_of_int ((10 - (!sum mod 10)) mod 10)

let validate number =
  let number = compact number in
  if not (Utils.is_digits number) then raise Invalid_format;
  if String.length number <> 11 then raise Invalid_length;
  if calc_check_digit (String.sub number 0 10) <> String.make 1 number.[10] then
    raise Invalid_checksum;
  number

let is_valid number =
  try
    ignore (validate number);
    true
  with Invalid_format | Invalid_length | Invalid_checksum -> false
