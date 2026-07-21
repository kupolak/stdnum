(** CVR (Momsregistreringsnummer, Danish VAT number).

    The CVR (Momsregistreringsnummer, VAT) is an 8 digit number with a
    straightforward check mechanism. *)

open Tools

exception Invalid_format
exception Invalid_length
exception Invalid_checksum

let compact number =
  let cleaned =
    Utils.clean number "[ -.,/:]" |> String.trim |> String.uppercase_ascii
  in
  if String.length cleaned >= 2 && String.sub cleaned 0 2 = "DK" then
    String.sub cleaned 2 (String.length cleaned - 2)
  else cleaned

let checksum number =
  let weights = [| 2; 7; 6; 5; 4; 3; 2; 1 |] in
  let sum = ref 0 in
  for i = 0 to 7 do
    let digit = int_of_char number.[i] - int_of_char '0' in
    sum := !sum + (weights.(i) * digit)
  done;
  !sum mod 11

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
