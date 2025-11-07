open Tools

exception Invalid_format
exception Invalid_length
exception Invalid_checksum

let compact number = Utils.clean number "[ -]" |> String.trim

let calc_check_digits number =
  (* Calculate first check digit (10th digit) *)
  let sum1 = ref 0 in
  for i = 0 to 8 do
    let digit = int_of_char number.[i] - int_of_char '0' in
    let weight = if i mod 2 = 0 then 3 else 1 in
    sum1 := !sum1 + (weight * digit)
  done;
  let check1 = (10 - (!sum1 mod 10)) mod 10 in

  (* Calculate second check digit (11th digit) *)
  let sum2 = ref check1 in
  for i = 0 to 8 do
    let digit = int_of_char number.[i] - int_of_char '0' in
    sum2 := !sum2 + digit
  done;
  let check2 = !sum2 mod 10 in

  Printf.sprintf "%d%d" check1 check2

let validate number =
  let number = compact number in
  if
    (not (Utils.is_digits number))
    || (String.length number > 0 && number.[0] = '0')
  then raise Invalid_format;
  if String.length number <> 11 then raise Invalid_length;

  let calculated = calc_check_digits (String.sub number 0 9) in
  let actual = String.sub number 9 2 in
  if calculated <> actual then raise Invalid_checksum;

  number

let is_valid number =
  try
    ignore (validate number);
    true
  with Invalid_format | Invalid_length | Invalid_checksum -> false

let format number = compact number
