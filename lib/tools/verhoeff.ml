exception Invalid_format
exception Invalid_checksum

(* Multiplication table used in the Verhoeff algorithm *)
let multiplication_table =
  [|
     [| 0; 1; 2; 3; 4; 5; 6; 7; 8; 9 |]
   ; [| 1; 2; 3; 4; 0; 6; 7; 8; 9; 5 |]
   ; [| 2; 3; 4; 0; 1; 7; 8; 9; 5; 6 |]
   ; [| 3; 4; 0; 1; 2; 8; 9; 5; 6; 7 |]
   ; [| 4; 0; 1; 2; 3; 9; 5; 6; 7; 8 |]
   ; [| 5; 9; 8; 7; 6; 0; 4; 3; 2; 1 |]
   ; [| 6; 5; 9; 8; 7; 1; 0; 4; 3; 2 |]
   ; [| 7; 6; 5; 9; 8; 2; 1; 0; 4; 3 |]
   ; [| 8; 7; 6; 5; 9; 3; 2; 1; 0; 4 |]
   ; [| 9; 8; 7; 6; 5; 4; 3; 2; 1; 0 |]
  |]

(* Permutation table used in the Verhoeff algorithm *)
let permutation_table =
  [|
     [| 0; 1; 2; 3; 4; 5; 6; 7; 8; 9 |]
   ; [| 1; 5; 7; 6; 2; 8; 3; 0; 9; 4 |]
   ; [| 5; 8; 0; 3; 7; 9; 6; 1; 4; 2 |]
   ; [| 8; 9; 1; 6; 0; 4; 3; 5; 2; 7 |]
   ; [| 9; 4; 5; 3; 1; 2; 6; 8; 7; 0 |]
   ; [| 4; 2; 8; 6; 5; 7; 3; 9; 0; 1 |]
   ; [| 2; 7; 9; 3; 8; 0; 6; 4; 1; 5 |]
   ; [| 7; 0; 4; 6; 9; 1; 3; 2; 5; 8 |]
  |]

let checksum number =
  let check = ref 0 in
  let len = String.length number in
  for i = 0 to len - 1 do
    let pos = len - 1 - i in
    (* reverse iteration *)
    let digit = int_of_char number.[pos] - int_of_char '0' in
    let perm_idx = i mod 8 in
    check :=
      multiplication_table.(!check).(permutation_table.(perm_idx).(digit))
  done;
  !check

let validate number =
  if String.length number = 0 then raise Invalid_format;
  let is_valid = try checksum number = 0 with _ -> false in
  if not is_valid then raise Invalid_checksum;
  number

let is_valid number =
  try
    ignore (validate number);
    true
  with Invalid_format | Invalid_checksum -> false

(* Find index of 0 in the array *)
let find_index_of_zero arr =
  let rec find i =
    if i >= Array.length arr then raise Not_found
    else if arr.(i) = 0 then i
    else find (i + 1)
  in
  find 0

let calc_check_digit number =
  let check = checksum (number ^ "0") in
  let index = find_index_of_zero multiplication_table.(check) in
  string_of_int index
