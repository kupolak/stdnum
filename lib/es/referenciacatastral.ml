open Tools

exception Invalid_length
exception Invalid_format
exception Invalid_checksum

let alphabet = "ABCDEFGHIJKLMNÑOPQRSTUVWXYZ0123456789"

let compact number =
  Utils.clean number "[ -]" |> String.uppercase_ascii |> String.trim

let format number =
  let number = compact number in
  String.sub number 0 7 ^ " " ^ String.sub number 7 7 ^ " "
  ^ String.sub number 14 4 ^ " " ^ String.sub number 18 2

let find_char_position c =
  (* Manually map characters to their position in the alphabet *)
  (* The alphabet is: ABCDEFGHIJKLMNÑOPQRSTUVWXYZ0123456789 *)
  match c with
  | 'A' -> 0
  | 'B' -> 1
  | 'C' -> 2
  | 'D' -> 3
  | 'E' -> 4
  | 'F' -> 5
  | 'G' -> 6
  | 'H' -> 7
  | 'I' -> 8
  | 'J' -> 9
  | 'K' -> 10
  | 'L' -> 11
  | 'M' -> 12
  | 'N' -> 13
  | 'O' -> 15
  | 'P' -> 16
  | 'Q' -> 17
  | 'R' -> 18
  | 'S' -> 19
  | 'T' -> 20
  | 'U' -> 21
  | 'V' -> 22
  | 'W' -> 23
  | 'X' -> 24
  | 'Y' -> 25
  | 'Z' -> 26
  | '0' -> 27
  | '1' -> 28
  | '2' -> 29
  | '3' -> 30
  | '4' -> 31
  | '5' -> 32
  | '6' -> 33
  | '7' -> 34
  | '8' -> 35
  | '9' -> 36
  | _ ->
      (* Check if it's Ñ (UTF-8) by checking the string starting at position *)
      if c = '\195' then 14 (* Ñ in UTF-8 is \195\145 *)
      else raise Invalid_format

let check_digit number =
  (* Calculate a single check digit on the provided part of the number *)
  let weights = [| 13; 15; 12; 5; 4; 17; 9; 21; 3; 7; 1 |] in
  let check_alphabet = "MQWERTYUIOPASDFGHJKLBZX" in

  let sum = ref 0 in
  let i_ref = ref 0 in
  let byte_idx = ref 0 in

  while !byte_idx < String.length number && !i_ref < 11 do
    let c = number.[!byte_idx] in
    let value =
      if c >= '0' && c <= '9' then (
        byte_idx := !byte_idx + 1;
        int_of_char c - int_of_char '0')
      else if
        c = '\195'
        && !byte_idx + 1 < String.length number
        && number.[!byte_idx + 1] = '\145'
      then (
        (* This is Ñ in UTF-8 *)
        byte_idx := !byte_idx + 2;
        14 + 1 (* Position 14, then add 1 *))
      else (
        byte_idx := !byte_idx + 1;
        find_char_position c + 1)
    in
    sum := !sum + (weights.(!i_ref) * value);
    i_ref := !i_ref + 1
  done;

  let check_index = !sum mod 23 in
  String.make 1 check_alphabet.[check_index]

let calc_check_digits number =
  let number = compact number in
  let first_part = String.sub number 0 7 ^ String.sub number 14 4 in
  let second_part = String.sub number 7 7 ^ String.sub number 14 4 in
  check_digit first_part ^ check_digit second_part

let validate number =
  let number = compact number in

  (* Check that all characters are in the alphabet *)
  for i = 0 to String.length number - 1 do
    if not (String.contains alphabet number.[i]) then raise Invalid_format
  done;

  if String.length number <> 20 then raise Invalid_length;

  (* Validate check digits *)
  let calculated = calc_check_digits number in
  let provided = String.sub number 18 2 in
  if calculated <> provided then raise Invalid_checksum;

  number

let is_valid number =
  try
    ignore (validate number);
    true
  with Invalid_format | Invalid_length | Invalid_checksum -> false
