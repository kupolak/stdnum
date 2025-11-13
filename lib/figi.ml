(** FIGI (Financial Instrument Global Identifier).

    The Financial Instrument Global Identifier (FIGI) is a 12-character
    alpha-numerical unique identifier of financial instruments such as common
    stock, options, derivatives, futures, corporate and government bonds,
    municipals, currencies, and mortgage products.

    More information:
    - https://openfigi.com/
    - https://en.wikipedia.org/wiki/Financial_Instrument_Global_Identifier *)

open Tools

exception Invalid_format
exception Invalid_length
exception Invalid_checksum
exception Invalid_component

(* FIGI uses a restricted alphabet - excludes A, E, I, O, U to avoid confusion *)
let figi_alphabet = "0123456789BCDFGHJKLMNPQRSTVWXYZ"

(* Full alphabet for check digit calculation *)
let full_alphabet = "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ"

let compact number =
  Utils.clean number "[ ]" |> String.trim |> String.uppercase_ascii

let calc_check_digit number =
  (* Convert each character to its numeric value and multiply by 1 or 2 based on position *)
  let number_str = ref "" in
  for i = 0 to 10 do
    let c = number.[i] in
    match String.index_opt full_alphabet c with
    | Some idx ->
        let multiplier = if i mod 2 = 0 then 1 else 2 in
        let value = idx * multiplier in
        number_str := !number_str ^ string_of_int value
    | None -> raise Invalid_format
  done;

  (* Sum all individual digits *)
  let sum = ref 0 in
  String.iter
    (fun c ->
      let digit = int_of_char c - int_of_char '0' in
      sum := !sum + digit)
    !number_str;

  (* Calculate check digit *)
  string_of_int ((10 - (!sum mod 10)) mod 10)

let validate number =
  let number = compact number in

  (* Check that all characters are in the FIGI alphabet *)
  if not (String.for_all (fun c -> String.contains figi_alphabet c) number) then
    raise Invalid_format;

  (* Check length: must be exactly 12 characters *)
  if String.length number <> 12 then raise Invalid_length;

  (* First two characters must not be digits *)
  let is_digit c = c >= '0' && c <= '9' in
  if is_digit number.[0] || is_digit number.[1] then raise Invalid_format;

  (* Check for reserved country codes *)
  let prefix = String.sub number 0 2 in
  if
    prefix = "BS" || prefix = "BM" || prefix = "GG" || prefix = "GB"
    || prefix = "VG"
  then raise Invalid_component;

  (* Third character must be 'G' *)
  if number.[2] <> 'G' then raise Invalid_component;

  (* Verify check digit *)
  let check_digit = String.sub number 11 1 in
  let number_part = String.sub number 0 11 in
  let expected_check = calc_check_digit number_part in
  if check_digit <> expected_check then raise Invalid_checksum;

  number

let is_valid number =
  try
    ignore (validate number);
    true
  with
  | Invalid_format | Invalid_length | Invalid_checksum | Invalid_component ->
    false
