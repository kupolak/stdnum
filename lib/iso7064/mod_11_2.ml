exception Invalid_format
exception Invalid_checksum

let checksum number =
  let check = ref 0 in
  for i = 0 to String.length number - 1 do
    let digit =
      match number.[i] with
      | 'X' | 'x' -> 10
      | c when c >= '0' && c <= '9' -> int_of_char c - int_of_char '0'
      | _ -> raise Invalid_format
    in
    check := ((2 * !check) + digit) mod 11
  done;
  !check

let calc_check_digit number =
  let c = (1 - (2 * checksum number)) mod 11 in
  (* Handle negative modulo to match Python behavior *)
  let c' = if c < 0 then c + 11 else c in
  if c' = 10 then "X" else string_of_int c'

let validate number =
  let is_valid = try checksum number = 1 with _ -> false in
  if not is_valid then raise Invalid_checksum;
  number

let is_valid number =
  try
    ignore (validate number);
    true
  with Invalid_format | Invalid_checksum -> false
