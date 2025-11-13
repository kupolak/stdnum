exception Invalid_format
exception Invalid_checksum

let to_base10 number =
  let res = ref "" in
  String.iter
    (fun x ->
      let digit =
        if x >= '0' && x <= '9' then
          string_of_int (int_of_char x - int_of_char '0')
        else if x >= 'A' && x <= 'Z' then
          string_of_int (int_of_char x - int_of_char 'A' + 10)
        else if x >= 'a' && x <= 'z' then
          string_of_int (int_of_char x - int_of_char 'a' + 10)
        else failwith "Invalid character in number"
      in
      res := !res ^ digit)
    number;
  !res

let checksum number =
  let digit_string = to_base10 number in
  (* Calculate mod 97 in chunks to avoid integer overflow *)
  let rec calc_mod acc i =
    if i >= String.length digit_string then acc
    else
      let chunk_end = min (i + 9) (String.length digit_string) in
      let chunk = String.sub digit_string i (chunk_end - i) in
      let value = int_of_string (string_of_int acc ^ chunk) in
      calc_mod (value mod 97) chunk_end
  in
  calc_mod 0 0

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
