open Tools

exception Invalid_length
exception Invalid_format
exception Invalid_component
exception Invalid_checksum

let compact number =
  let number =
    Utils.clean number "[ -]" |> String.uppercase_ascii |> String.trim
  in
  if String.length number >= 2 && String.sub number 0 2 = "UY" then
    String.sub number 2 (String.length number - 2)
  else number

let calc_check_digit number =
  (* number must be first 11 digits *)
  let weights = [| 4; 3; 2; 9; 8; 7; 6; 5; 4; 3; 2 |] in
  let total =
    Array.init 11 (fun i ->
        (int_of_char number.[i] - int_of_char '0') * weights.(i))
    |> Array.fold_left ( + ) 0
  in
  (11 - (total mod 11)) mod 11 |> string_of_int

let validate number =
  let number = compact number in
  if String.length number <> 12 then raise Invalid_length;
  if not (Utils.is_digits number) then raise Invalid_format;
  (* registration code 01..22 *)
  let reg = String.sub number 0 2 in
  if reg < "01" || reg > "22" then raise Invalid_component;
  (* sequence not all zeros *)
  if String.sub number 2 6 = "000000" then raise Invalid_component;
  (* fixed block 001 *)
  if String.sub number 8 3 <> "001" then raise Invalid_component;
  if String.sub number 11 1 <> calc_check_digit number then
    raise Invalid_checksum;
  number

let is_valid number =
  try
    ignore (validate number);
    true
  with
  | Invalid_length | Invalid_format | Invalid_component | Invalid_checksum ->
    false

let format number =
  let number = compact number in
  Printf.sprintf "%s-%s-%s-%s" (String.sub number 0 2) (String.sub number 2 6)
    (String.sub number 8 3) (String.sub number 11 1)
