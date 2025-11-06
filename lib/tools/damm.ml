exception Invalid_format
exception Invalid_checksum

(* Default Damm operation table from Wikipedia *)
let default_table =
  [|
     [| 0; 3; 1; 7; 5; 9; 8; 6; 4; 2 |]
   ; [| 7; 0; 9; 2; 1; 5; 4; 8; 6; 3 |]
   ; [| 4; 2; 0; 6; 8; 7; 1; 3; 5; 9 |]
   ; [| 1; 7; 5; 0; 9; 8; 3; 4; 2; 6 |]
   ; [| 6; 1; 2; 3; 0; 4; 5; 9; 7; 8 |]
   ; [| 3; 6; 7; 4; 2; 0; 9; 5; 8; 1 |]
   ; [| 5; 8; 6; 9; 7; 2; 0; 1; 3; 4 |]
   ; [| 8; 9; 4; 5; 3; 6; 2; 0; 1; 7 |]
   ; [| 9; 4; 3; 8; 6; 1; 7; 2; 0; 5 |]
   ; [| 2; 5; 8; 1; 4; 3; 6; 7; 9; 0 |]
  |]

let checksum ?(table = default_table) number =
  let i = ref 0 in
  for j = 0 to String.length number - 1 do
    let digit = int_of_char number.[j] - int_of_char '0' in
    i := table.(!i).(digit)
  done;
  !i

let validate ?(table = default_table) number =
  if String.length number = 0 then raise Invalid_format;
  let is_valid = try checksum ~table number = 0 with _ -> false in
  if not is_valid then raise Invalid_checksum;
  number

let is_valid ?(table = default_table) number =
  try
    ignore (validate ~table number);
    true
  with Invalid_format | Invalid_checksum -> false

let calc_check_digit ?(table = default_table) number =
  string_of_int (checksum ~table number)
