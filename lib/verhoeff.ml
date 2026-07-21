(** The Verhoeff algorithm.

    The Verhoeff algorithm is a checksum algorithm that should catch most common
    (typing) errors in numbers. The algorithm uses two tables for permutations
    and multiplications and as a result is more complex than the Luhn algorithm.

    More information:
    - https://en.wikipedia.org/wiki/Verhoeff_algorithm
    - https://en.wikibooks.org/wiki/Algorithm_Implementation/Checksums/Verhoeff_Algorithm *)

exception Invalid_format
exception Invalid_checksum

let multiplication_table = [|
  [| 0; 1; 2; 3; 4; 5; 6; 7; 8; 9 |];
  [| 1; 2; 3; 4; 0; 6; 7; 8; 9; 5 |];
  [| 2; 3; 4; 0; 1; 7; 8; 9; 5; 6 |];
  [| 3; 4; 0; 1; 2; 8; 9; 5; 6; 7 |];
  [| 4; 0; 1; 2; 3; 9; 5; 6; 7; 8 |];
  [| 5; 9; 8; 7; 6; 0; 4; 3; 2; 1 |];
  [| 6; 5; 9; 8; 7; 1; 0; 4; 3; 2 |];
  [| 7; 6; 5; 9; 8; 2; 1; 0; 4; 3 |];
  [| 8; 7; 6; 5; 9; 3; 2; 1; 0; 4 |];
  [| 9; 8; 7; 6; 5; 4; 3; 2; 1; 0 |];
|]

let permutation_table = [|
  [| 0; 1; 2; 3; 4; 5; 6; 7; 8; 9 |];
  [| 1; 5; 7; 6; 2; 8; 3; 0; 9; 4 |];
  [| 5; 8; 0; 3; 7; 9; 6; 1; 4; 2 |];
  [| 8; 9; 1; 6; 0; 4; 3; 5; 2; 7 |];
  [| 9; 4; 5; 3; 1; 2; 6; 8; 7; 0 |];
  [| 4; 2; 8; 6; 5; 7; 3; 9; 0; 1 |];
  [| 2; 7; 9; 3; 8; 0; 6; 4; 1; 5 |];
  [| 7; 0; 4; 6; 9; 1; 3; 2; 5; 8 |];
|]

let checksum number =
  let len = String.length number in
  let check = ref 0 in
  for i = 0 to len - 1 do
    let n = int_of_char number.[len - 1 - i] - int_of_char '0' in
    check := multiplication_table.(!check).(permutation_table.(i mod 8).(n))
  done;
  !check

let validate number =
  if String.length number = 0 then raise Invalid_format;
  let valid = try checksum number = 0 with _ -> raise Invalid_format in
  if not valid then raise Invalid_checksum;
  number

let is_valid number =
  try
    ignore (validate number);
    true
  with Invalid_format | Invalid_checksum -> false

let calc_check_digit number =
  let chk = checksum (number ^ "0") in
  let rec find_index i =
    if i >= 10 then failwith "Not found"
    else if multiplication_table.(chk).(i) = 0 then string_of_int i
    else find_index (i + 1)
  in
  find_index 0
