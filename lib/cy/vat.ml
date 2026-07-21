(** Αριθμός Εγγραφής Φ.Π.Α. (Cypriot VAT number).

    The Cypriot Αριθμός Εγγραφής Φ.Π.Α. (VAT) number consists of 9 digits where
    the last one is a is a letter and functions as a check digit. *)

open Tools

exception Invalid_format
exception Invalid_length
exception Invalid_component
exception Invalid_checksum

let compact number =
  let cleaned =
    Utils.clean number "[ -]" |> String.trim |> String.uppercase_ascii
  in
  if String.length cleaned >= 2 && String.sub cleaned 0 2 = "CY" then
    String.sub cleaned 2 (String.length cleaned - 2)
  else cleaned

let calc_check_digit number =
  let translation = [| 1; 0; 5; 7; 9; 13; 15; 17; 19; 21 |] in
  let sum = ref 0 in
  for i = 0 to 7 do
    let digit = int_of_char number.[i] - int_of_char '0' in
    if i mod 2 = 0 then sum := !sum + translation.(digit)
    else sum := !sum + digit
  done;
  let letters = "ABCDEFGHIJKLMNOPQRSTUVWXYZ" in
  String.make 1 letters.[!sum mod 26]

let validate number =
  let number = compact number in
  let len = String.length number in
  if len <> 9 then raise Invalid_length;

  let prefix = String.sub number 0 8 in
  if not (Utils.is_digits prefix) then raise Invalid_format;

  if String.sub number 0 2 = "12" then raise Invalid_component;

  let check_digit = String.sub number 8 1 in
  if check_digit <> calc_check_digit prefix then raise Invalid_checksum;

  number

let is_valid number =
  try
    ignore (validate number);
    true
  with
  | Invalid_format | Invalid_length | Invalid_component | Invalid_checksum ->
    false
