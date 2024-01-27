exception Invalid_format
exception Invalid_checksum

let to_base10 number =
  let res = ref "" in
  String.iter
    (fun x -> res := !res ^ string_of_int (int_of_char x - int_of_char '0'))
    number;
  !res

let checksum number = int_of_string (to_base10 number) mod 97

let calc_check_digits number =
  Printf.sprintf "%02d" (98 - checksum (number ^ "00"))

let validate number =
  try
    let valid = checksum number = 1 in
    if not valid then raise Invalid_checksum;
    number
  with _ -> raise Invalid_format

let is_valid number =
  try
    ignore (validate number);
    true
  with Invalid_format | Invalid_checksum -> false
