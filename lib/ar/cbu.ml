open Tools

exception Invalid_length
exception Invalid_format
exception Invalid_checksum

let compact number = Utils.clean number " -" |> String.trim

let calc_check_digit number =
  let weights = [| 3; 1; 7; 9 |] in
  let len = String.length number in
  let rec sum i acc =
    if i < len then
      let w = weights.(i mod 4) in
      let n = int_of_char number.[len - 1 - i] - int_of_char '0' in
      sum (i + 1) (acc + (w * n))
    else acc
  in
  let check = (10 - (sum 0 0 mod 10)) mod 10 in
  string_of_int check

let validate number =
  let cleaned = compact number in

  (* Check for non-digits in cleaned string *)
  if not (String.for_all (fun c -> c >= '0' && c <= '9') cleaned) then
    raise Invalid_format;

  (* Length check after format validation *)
  if String.length cleaned <> 22 then raise Invalid_length;

  let first_part = String.sub cleaned 0 7 in
  let second_part = String.sub cleaned 8 13 in
  let check1 = calc_check_digit first_part in
  let check2 = calc_check_digit second_part in
  if String.get cleaned 7 <> String.get check1 0 then raise Invalid_checksum
  else if String.get cleaned 21 <> String.get check2 0 then
    raise Invalid_checksum
  else cleaned

let is_valid number =
  try
    let _ = validate number in
    true
  with Invalid_format | Invalid_length | Invalid_checksum -> false

let format number =
  let number = compact number in
  String.sub number 0 8 ^ " " ^ String.sub number 8 14
