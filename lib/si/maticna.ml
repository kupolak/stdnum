open Tools

exception Invalid_length
exception Invalid_format
exception Invalid_checksum

let compact number =
  let cleaned =
    Utils.clean number "[. ]" |> String.trim |> String.uppercase_ascii
  in
  let len = String.length cleaned in
  if len = 10 && String.sub cleaned 7 3 = "000" then String.sub cleaned 0 7
  else cleaned

let calc_check_digit number =
  let weights = [| 7; 6; 5; 4; 3; 2 |] in
  let total = ref 0 in
  for i = 0 to 5 do
    let digit = int_of_char number.[i] - int_of_char '0' in
    total := !total + (digit * weights.(i))
  done;
  let remainder = (11 - (!total mod 11)) mod 11 in
  if remainder = 0 then "invalid" (* invalid remainder *)
  else string_of_int (remainder mod 10)

let validate number =
  let number = compact number in
  let len = String.length number in
  if len <> 7 && len <> 10 then raise Invalid_length;
  (* First 6 digits must be digits *)
  if not (Utils.is_digits (String.sub number 0 6)) then raise Invalid_format;
  (* If length is 10, check the last 3 characters (business unit) *)
  (if len = 10 then
     let business_unit = String.sub number 7 3 in
     (* Business unit must match: optional letter/digit followed by 2 digits *)
     let first_char = business_unit.[0] in
     let second_char = business_unit.[1] in
     let third_char = business_unit.[2] in
     let is_first_valid =
       (first_char >= '0' && first_char <= '9')
       || (first_char >= 'A' && first_char <= 'Z')
     in
     let is_second_digit = second_char >= '0' && second_char <= '9' in
     let is_third_digit = third_char >= '0' && third_char <= '9' in
     if not (is_first_valid && is_second_digit && is_third_digit) then
       raise Invalid_format);
  (* Check digit validation *)
  let check_digit = calc_check_digit number in
  if check_digit = "invalid" then raise Invalid_checksum;
  if String.make 1 number.[6] <> check_digit then raise Invalid_checksum;
  number

let is_valid number =
  try
    ignore (validate number);
    true
  with Invalid_format | Invalid_length | Invalid_checksum -> false
