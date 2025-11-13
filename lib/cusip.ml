(** CUSIP number (financial security identification number).

    CUSIP (Committee on Uniform Securities Identification Procedures) numbers are
    used to identify financial securities. CUSIP numbers are a nine-character
    alphanumeric code where the first six characters identify the issuer,
    followed by two digits that identify the issue, and a check digit.

    More information:
    - https://en.wikipedia.org/wiki/CUSIP
    - https://www.cusip.com/ *)

open Tools

exception Invalid_format
exception Invalid_length
exception Invalid_checksum

(* CUSIP alphabet includes digits, letters, and special characters *)
let alphabet = "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ*@#"

let compact number =
  Utils.clean number "[ ]" |> String.trim |> String.uppercase_ascii

let calc_check_digit number =
  (* Convert each character to its numeric value and multiply by 1 or 2 based on position *)
  let number_str = ref "" in
  String.iteri
    (fun i c ->
      match String.index_opt alphabet c with
      | Some idx ->
          let multiplier = if i mod 2 = 0 then 1 else 2 in
          let value = idx * multiplier in
          number_str := !number_str ^ string_of_int value
      | None -> raise Invalid_format)
    number;

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

  (* Check that all characters are in the alphabet *)
  if not (String.for_all (fun c -> String.contains alphabet c) number) then
    raise Invalid_format;

  (* Check length: must be exactly 9 characters *)
  if String.length number <> 9 then raise Invalid_length;

  (* Verify check digit *)
  let check_digit = String.sub number 8 1 in
  let number_part = String.sub number 0 8 in
  let expected_check = calc_check_digit number_part in
  if check_digit <> expected_check then raise Invalid_checksum;

  number

let is_valid number =
  try
    ignore (validate number);
    true
  with Invalid_format | Invalid_length | Invalid_checksum -> false

let to_isin number =
  let number = validate number in
  (* Convert CUSIP to ISIN by prepending "US" and calculating Luhn check digit *)
  let base = "US" ^ number in

  (* Convert to digits (same logic as WKN module) *)
  let to_digits s =
    let result = ref [] in
    String.iter
      (fun c ->
        if c >= '0' && c <= '9' then
          result := (int_of_char c - int_of_char '0') :: !result
        else if c >= 'A' && c <= 'Z' then
          let value = int_of_char c - int_of_char 'A' + 10 in
          result := (value mod 10) :: (value / 10) :: !result
        else if c = '*' then
          let value = 36 in
          result := (value mod 10) :: (value / 10) :: !result
        else if c = '@' then
          let value = 37 in
          result := (value mod 10) :: (value / 10) :: !result
        else if c = '#' then
          let value = 38 in
          result := (value mod 10) :: (value / 10) :: !result)
      s;
    List.rev !result
  in
  let digits = to_digits base in
  let len = List.length digits in

  (* Luhn algorithm *)
  let rec luhn_sum idx ds sum =
    match ds with
    | [] -> sum
    | d :: rest ->
        let pos_from_right = len - idx - 1 in
        let should_double = pos_from_right mod 2 = 0 in
        let value = if should_double then d * 2 else d in
        let value = if value > 9 then value - 9 else value in
        luhn_sum (idx + 1) rest (sum + value)
  in
  let sum = luhn_sum 0 digits 0 in
  let check_digit = (10 - (sum mod 10)) mod 10 in
  base ^ string_of_int check_digit
