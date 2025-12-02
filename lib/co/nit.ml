open Tools

exception Invalid_format
exception Invalid_length
exception Invalid_checksum

(** Convert the number to the minimal representation. This strips
    surrounding whitespace and separation characters. *)
let compact number =
  Utils.clean number "[., -]" |> String.uppercase_ascii |> String.trim

(** Calculate the check digit. The number passed should not have the
    check digit included. *)
let calc_check_digit number =
  let weights = [| 3; 7; 13; 17; 19; 23; 29; 37; 41; 43; 47; 53; 59; 67; 71 |] in
  let sum = ref 0 in
  let len = String.length number in
  (* Process digits in reverse order *)
  for i = 0 to len - 1 do
    let digit = Char.code number.[len - 1 - i] - Char.code '0' in
    let weight = weights.(i) in
    sum := !sum + (weight * digit)
  done;
  let s = !sum mod 11 in
  String.make 1 "01987654321".[s]

(** Check if the number is a valid NIT. This checks the length, formatting
    and check digit. *)
let validate number =
  let number = compact number in
  let len = String.length number in
  if len < 8 || len > 16 then raise Invalid_length;
  if not (Utils.is_digits number) then raise Invalid_format;
  let check_digit = calc_check_digit (String.sub number 0 (len - 1)) in
  if check_digit <> String.make 1 number.[len - 1] then
    raise Invalid_checksum;
  number

(** Check if the number is a valid NIT. *)
let is_valid number =
  try
    let _ = validate number in
    true
  with Invalid_format | Invalid_length | Invalid_checksum -> false

(** Reformat the number to the standard presentation format. *)
let format number =
  let number = compact number in
  let len = String.length number in
  
  let (main_part, last_part) =
    if len <= 10 then
      (* For numbers up to 10 digits: all but last digit, and the check digit *)
      (String.sub number 0 (len - 1), String.make 1 number.[len - 1])
    else
      (* For numbers over 10 digits: all but last 3 digits, and the last 3 digits *)
      (String.sub number 0 (len - 3), String.sub number (len - 3) 3)
  in
  
  (* Build groups of 3 from left to right, with first group potentially < 3 *)
  let main_len = String.length main_part in
  let first_group_len = main_len mod 3 in
  let first_group_len = if first_group_len = 0 then 3 else first_group_len in
  
  let rec build_groups s acc pos first_group =
    if pos >= String.length s then
      acc
    else
      let group_len = if first_group then first_group_len else 3 in
      let group_len = min group_len (String.length s - pos) in
      let group = String.sub s pos group_len in
      let new_acc = if String.length acc = 0 then group else acc ^ "." ^ group in
      build_groups s new_acc (pos + group_len) false
  in
  
  let formatted = build_groups main_part "" 0 true in
  formatted ^ "-" ^ last_part
