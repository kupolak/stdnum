open Tools

exception Invalid_format
exception Invalid_length
exception Invalid_checksum

(* Alphabet used in USCC: 0-9 and A-H, J-N, P, Q, R, T, U, W, X, Y *)
(* Excludes: I, O, Z, S, V *)
let _alphabet = "0123456789ABCDEFGHJKLMNPQRTUWXY"

(** Convert the number to the minimal representation. This strips
    surrounding whitespace and separation characters. *)
let compact number =
  Utils.clean number "[ -]" |> String.uppercase_ascii |> String.trim

(** Get the index of a character in the alphabet. *)
let char_index c = try String.index _alphabet c with Not_found -> -1

(** Calculate the check digit. The number passed should have 17 characters
    (without the check digit). *)
let calc_check_digit number =
  let weights =
    [| 1; 3; 9; 27; 19; 26; 16; 17; 20; 29; 25; 13; 8; 24; 10; 30; 28 |]
  in
  let number = compact number in
  let sum = ref 0 in
  for i = 0 to String.length number - 1 do
    let idx = char_index number.[i] in
    if idx >= 0 then sum := !sum + (idx * weights.(i))
  done;
  let check_idx = (31 - (!sum mod 31)) mod 31 in
  String.make 1 _alphabet.[check_idx]

(** Check if all characters in the first 8 characters are digits. *)
let is_first_8_digits number =
  if String.length number < 8 then false
  else
    let rec check i =
      if i >= 8 then true
      else
        let c = number.[i] in
        let is_digit =
          Char.code c >= Char.code '0' && Char.code c <= Char.code '9'
        in
        if is_digit then check (i + 1) else false
    in
    check 0

(** Check if a character is valid in the alphabet. *)
let is_valid_char c = char_index c >= 0

(** Check if all characters from position start to end are valid. *)
let all_valid_chars number start end_pos =
  let rec check i =
    if i > end_pos then true
    else if is_valid_char number.[i] then check (i + 1)
    else false
  in
  check start

(** Check if the number is a valid USCC. This checks the length, formatting
    and check digit. *)
let validate number =
  let number = compact number in
  let len = String.length number in
  if len <> 18 then raise Invalid_length;
  if not (is_first_8_digits number) then raise Invalid_format;
  if not (all_valid_chars number 8 17) then raise Invalid_format;
  let expected_check = calc_check_digit (String.sub number 0 17) in
  if expected_check <> String.make 1 number.[17] then raise Invalid_checksum;
  number

(** Check if the number is a valid USCC. *)
let is_valid number =
  try
    let _ = validate number in
    true
  with Invalid_format | Invalid_length | Invalid_checksum -> false

(** Reformat the number to the standard presentation format. *)
let format number = compact number
