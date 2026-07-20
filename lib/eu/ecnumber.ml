(** EC Number (European Community number).

    The EC Number is a unique seven-digit number assigned to chemical substances
    for regulatory purposes within the European Union by the European Commission.

    More information:
    - https://en.wikipedia.org/wiki/European_Community_number *)

open Tools

exception Invalid_format
exception Invalid_length
exception Invalid_checksum

let compact number =
  let cleaned = Utils.clean number " " |> String.trim in
  if not (String.contains cleaned '-') then
    let len = String.length cleaned in
    if len >= 7 then
      String.sub cleaned 0 3 ^ "-" ^ String.sub cleaned 3 3 ^ "-" ^ String.sub cleaned 6 (len - 6)
    else cleaned
  else cleaned

let calc_check_digit number =
  let number = compact number in
  let number_no_dash = Utils.clean number "-" in
  let sum = ref 0 in
  String.iteri (fun i c ->
    let n = int_of_char c - int_of_char '0' in
    sum := !sum + ((i + 1) * n)
  ) number_no_dash;
  let check = !sum mod 11 in
  let s = string_of_int check in
  String.sub s 0 1

let validate number =
  let number = compact number in
  if String.length number <> 9 then raise Invalid_length;
  if not (Utils.is_digits (String.sub number 0 3)) ||
     number.[3] <> '-' ||
     not (Utils.is_digits (String.sub number 4 3)) ||
     number.[7] <> '-' ||
     not (Utils.is_digits (String.sub number 8 1)) then
    raise Invalid_format;
  let check_digit = calc_check_digit (String.sub number 0 8) in
  if String.sub number 8 1 <> check_digit then raise Invalid_checksum;
  number

let is_valid number =
  try
    ignore (validate number);
    true
  with Invalid_format | Invalid_length | Invalid_checksum -> false
