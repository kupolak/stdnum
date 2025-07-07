open Tools

exception Invalid_format
exception Invalid_length
exception Invalid_checksum

let compact number = Utils.clean number " " |> String.trim

let calc_check_digit number =
  let weights = [| -1; 5; 7; 9; 4; 6; 10; 5; 7 |] in
  let total = ref 0 in
  for i = 0 to 8 do
    let digit = int_of_string (String.sub number i 1) in
    total := !total + (weights.(i) * digit)
  done;
  string_of_int (!total mod 11 mod 10)

let validate number =
  let compact_number = compact number in

  if String.length compact_number <> 10 then raise Invalid_length;

  if not (Utils.is_digits compact_number) then raise Invalid_format;

  let check_digit = String.sub compact_number 9 1 in
  let calculated_check_digit = calc_check_digit compact_number in

  if check_digit <> calculated_check_digit then raise Invalid_checksum;

  compact_number

let is_valid number =
  try
    ignore (validate number);
    true
  with Invalid_format | Invalid_length | Invalid_checksum -> false

let format number = compact number
