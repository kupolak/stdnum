open Tools

exception Invalid_format
exception Invalid_length
exception Invalid_checksum

let compact number = Utils.clean number "[ -]" |> String.trim

let calc_check_digit number =
  let s = ref 0 in
  let first_nine = String.sub number 0 9 in
  for i = 0 to 8 do
    let n = int_of_char first_nine.[8 - i] - int_of_char '0' in
    let c1 = (n + i + 1) mod 10 in
    if c1 <> 0 then
      let c2 = c1 * Int.shift_left 1 (i + 1) mod 9 in
      let c2 = if c2 = 0 then 9 else c2 in
      s := !s + c2
  done;
  string_of_int ((((10 - !s) mod 10) + 10) mod 10)

let validate number =
  let number = compact number in
  if not (Utils.is_digits number) then raise Invalid_format;
  if String.length number <> 10 then raise Invalid_length;
  if calc_check_digit number <> String.make 1 number.[9] then
    raise Invalid_checksum;
  number

let is_valid number =
  try
    ignore (validate number);
    true
  with Invalid_format | Invalid_length | Invalid_checksum -> false
