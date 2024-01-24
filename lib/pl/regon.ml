open Tools

exception Invalid_format
exception Invalid_length
exception Invalid_checksum

let compact number =
  Utils.clean number "-" |> String.uppercase_ascii |> String.trim

let calc_check_digit number =
  let len = String.length number in
  let weights =
    if len = 8 then [ 8; 9; 2; 3; 4; 5; 6; 7 ]
    else [ 2; 4; 8; 5; 0; 9; 7; 3; 6; 1; 2; 4; 8 ]
  in
  let rec sum i acc =
    if i < len then
      let w = List.nth weights i in
      let n = int_of_char number.[i] - int_of_char '0' in
      sum (i + 1) (acc + (w * n))
    else acc
  in
  string_of_int (sum 0 0 mod 11 mod 10)

let validate number =
  let number = compact number in
  if not (Utils.is_digits number) then raise Invalid_format
  else if not (List.mem (String.length number) [ 9; 14 ]) then
    raise Invalid_length
  else if
    number.[String.length number - 1]
    <> (calc_check_digit (String.sub number 0 (String.length number - 1))).[0]
  then raise Invalid_checksum
  else if
    String.length number = 14
    && number.[8] <> (calc_check_digit (String.sub number 0 8)).[0]
  then raise Invalid_checksum
  else number

let is_valid number =
  try
    ignore (validate number);
    true
  with Invalid_format | Invalid_length | Invalid_checksum -> false
