(** Konto nr. (Norwegian bank account number)

    Konto nr. is the country-specific part in Norwegian IBAN codes. The number
    consists of 11 digits, the first 4 are the bank identifier and the last is a
    check digit. This module does not check if the bank identifier exists.

    More information:
    - https://www.ecbs.org/iban/norway-bank-account-number.html *)

open Tools

exception Invalid_format
exception Invalid_length
exception Invalid_checksum

let compact number =
  let number = Utils.clean number "[ .\\-]" |> String.trim in
  (* Strip leading 0000 postgiro bank code *)
  if String.length number >= 4 && String.sub number 0 4 = "0000" then
    String.sub number 4 (String.length number - 4)
  else number

let calc_check_digit number =
  let weights = [ 6; 7; 8; 9; 4; 5; 6; 7; 8; 9 ] in
  let number_list =
    List.map (fun x -> int_of_char x - 48) (List.of_seq (String.to_seq number))
  in
  let sum =
    List.fold_left2 (fun acc w n -> acc + (w * n)) 0 weights number_list
  in
  string_of_int (sum mod 11)

(* Luhn algorithm for 7-digit postgiro numbers *)
let luhn_validate number =
  if not (Utils.is_digits number) then raise Invalid_format;
  let len = String.length number in
  let sum = ref 0 in
  for i = 0 to len - 1 do
    let n = int_of_string (String.make 1 number.[len - 1 - i]) in
    let v =
      if i mod 2 = 1 then
        let d = n * 2 in
        if d > 9 then d - 9 else d
      else n
    in
    sum := !sum + v
  done;
  if !sum mod 10 <> 0 then raise Invalid_checksum

let validate number =
  let number = compact number in
  if not (Utils.is_digits number) then raise Invalid_format;
  let len = String.length number in
  if len = 7 then (
    (* 7-digit postgiro number uses Luhn *)
    luhn_validate number;
    number)
  else if len = 11 then (
    (* 11-digit number uses modulo 11 check digit *)
    if String.make 1 number.[10] <> calc_check_digit (String.sub number 0 10)
    then raise Invalid_checksum;
    number)
  else raise Invalid_length

let is_valid number =
  try
    ignore (validate number);
    true
  with Invalid_format | Invalid_length | Invalid_checksum -> false

let format number =
  let number = compact number in
  (* Pad to 11 digits with leading zeros *)
  let padded =
    if String.length number < 11 then
      String.make (11 - String.length number) '0' ^ number
    else number
  in
  String.sub padded 0 4 ^ "." ^ String.sub padded 4 2 ^ "."
  ^ String.sub padded 6 5

let to_iban number =
  (* We need to calculate IBAN check digits *)
  (* This is a simplified version - full implementation would need the generic IBAN module *)
  let number = compact number in
  let padded =
    if String.length number < 11 then
      String.make (11 - String.length number) '0' ^ number
    else number
  in
  (* Calculate IBAN check digits: "NO" + account number + "NO00" -> convert to numbers -> mod 97 *)
  let reordered = padded ^ "232400" in
  (* N=23, O=24, 00 at the end *)
  let remainder = int_of_string reordered mod 97 in
  let check_digits = 98 - remainder in
  Printf.sprintf "NO%02d %s" check_digits number
