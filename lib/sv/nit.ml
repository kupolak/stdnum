open Tools

exception Invalid_length
exception Invalid_format
exception Invalid_component
exception Invalid_checksum

let compact number =
  let cleaned =
    Utils.clean number "[ -]" |> String.uppercase_ascii |> String.trim
  in
  if String.length cleaned >= 2 && String.sub cleaned 0 2 = "SV" then
    String.sub cleaned 2 (String.length cleaned - 2)
  else cleaned

let calc_check_digit number =
  (* Old NIT: sequential number <= 100 *)
  let sequential = String.sub number 10 3 in
  if int_of_string sequential <= 100 then (
    (* Old algorithm *)
    let weights = [| 14; 13; 12; 11; 10; 9; 8; 7; 6; 5; 4; 3; 2 |] in
    let total = ref 0 in
    for i = 0 to 12 do
      let digit = int_of_char number.[i] - int_of_char '0' in
      total := !total + (digit * weights.(i))
    done;
    string_of_int (!total mod 11 mod 10))
  else
    (* New algorithm *)
    let weights = [| 2; 7; 6; 5; 4; 3; 2; 7; 6; 5; 4; 3; 2 |] in
    let total = ref 0 in
    for i = 0 to 12 do
      let digit = int_of_char number.[i] - int_of_char '0' in
      total := !total + (digit * weights.(i))
    done;
    let check = (11 + (- !total mod 11)) mod 11 in
    string_of_int (check mod 10)

let validate number =
  let number = compact number in
  if String.length number <> 14 then raise Invalid_length;
  if not (Utils.is_digits number) then raise Invalid_format;
  let first_char = number.[0] in
  if first_char <> '0' && first_char <> '1' && first_char <> '9' then
    raise Invalid_component;
  if String.make 1 number.[13] <> calc_check_digit number then
    raise Invalid_checksum;
  number

let is_valid number =
  try
    ignore (validate number);
    true
  with
  | Invalid_format | Invalid_length | Invalid_component | Invalid_checksum ->
    false

let format number =
  let number = compact number in
  String.sub number 0 4 ^ "-" ^ String.sub number 4 6 ^ "-"
  ^ String.sub number 10 3 ^ "-" ^ String.sub number 13 1
