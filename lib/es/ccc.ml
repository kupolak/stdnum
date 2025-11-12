open Tools

exception Invalid_length
exception Invalid_format
exception Invalid_checksum

let compact number =
  Utils.clean number "[ -]" |> String.trim |> String.uppercase_ascii

let format number =
  let number = compact number in
  String.concat " "
    [
      String.sub number 0 4
    ; String.sub number 4 4
    ; String.sub number 8 2
    ; String.sub number 10 5
    ; String.sub number 15 5
    ]

let calc_check_digit_internal number =
  (* Calculate a single check digit on the provided part of the number *)
  let sum = ref 0 in
  let len = String.length number in
  for i = 0 to len - 1 do
    let digit = int_of_char number.[i] - int_of_char '0' in
    let weight = 1 lsl i in
    (* 2^i *)
    sum := !sum + (digit * weight)
  done;
  let check = !sum mod 11 in
  if check < 2 then string_of_int check else string_of_int (11 - check)

let calc_check_digits number =
  (* Calculate the check digits for the number. The supplied number should
     have check digits included but are ignored. *)
  let number = compact number in
  let first_part = "00" ^ String.sub number 0 8 in
  let second_part = String.sub number 10 10 in
  calc_check_digit_internal first_part ^ calc_check_digit_internal second_part

let validate number =
  let number = compact number in
  if String.length number <> 20 then raise Invalid_length;
  if not (Utils.is_digits number) then raise Invalid_format;
  let calculated = calc_check_digits number in
  let provided = String.sub number 8 2 in
  if calculated <> provided then raise Invalid_checksum;
  number

let is_valid number =
  try
    ignore (validate number);
    true
  with Invalid_format | Invalid_length | Invalid_checksum -> false

let to_iban number =
  (* Convert the number to an IBAN *)
  let has_separator = String.contains number ' ' in
  let number = compact number in
  (* Calculate IBAN check digits *)
  (* IBAN = ES + check digits + CCC *)
  (* To calculate: move ES00 to end, replace letters with numbers (E=14, S=28) *)
  (* Then calculate mod 97 *)
  let base = number ^ "142800" in

  (* ES00 moved to end: E=14, S=28, 00=00 *)

  (* Calculate mod 97 for large number string *)
  let rec mod97_string s =
    if String.length s <= 9 then int_of_string s mod 97
    else
      let chunk = String.sub s 0 9 in
      let rest = String.sub s 9 (String.length s - 9) in
      let remainder = int_of_string chunk mod 97 in
      mod97_string (string_of_int remainder ^ rest)
  in

  let remainder = mod97_string base in
  let check_digits = 98 - remainder in
  let check_str = Printf.sprintf "%02d" check_digits in

  if has_separator then "ES" ^ check_str ^ " " ^ number
  else "ES" ^ check_str ^ number
