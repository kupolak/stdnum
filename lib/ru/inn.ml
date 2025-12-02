open Tools

exception Invalid_format
exception Invalid_length
exception Invalid_checksum

let compact number = Utils.clean number " " |> String.trim

let calc_company_check_digit number =
  (* Calculate the check digit for the 10-digit INN for organisations *)
  let weights = [| 2; 4; 10; 3; 5; 9; 4; 6; 8 |] in
  let total = ref 0 in
  for i = 0 to 8 do
    let digit = int_of_char number.[i] - int_of_char '0' in
    total := !total + (weights.(i) * digit)
  done;
  string_of_int (!total mod 11 mod 10)

let calc_personal_check_digits number =
  (* Calculate the check digits for the 12-digit personal INN *)
  let weights1 = [| 7; 2; 4; 10; 3; 5; 9; 4; 6; 8 |] in
  let total1 = ref 0 in
  for i = 0 to 9 do
    let digit = int_of_char number.[i] - int_of_char '0' in
    total1 := !total1 + (weights1.(i) * digit)
  done;
  let d1 = string_of_int (!total1 mod 11 mod 10) in

  let weights2 = [| 3; 7; 2; 4; 10; 3; 5; 9; 4; 6; 8 |] in
  let total2 = ref 0 in
  for i = 0 to 9 do
    let digit = int_of_char number.[i] - int_of_char '0' in
    total2 := !total2 + (weights2.(i) * digit)
  done;
  (* Add the first check digit for the second calculation *)
  let d1_digit = int_of_char d1.[0] - int_of_char '0' in
  total2 := !total2 + (weights2.(10) * d1_digit);
  let d2 = string_of_int (!total2 mod 11 mod 10) in

  d1 ^ d2

let validate number =
  let number = compact number in

  if not (Utils.is_digits number) then raise Invalid_format;

  match String.length number with
  | 10 ->
      (* Company INN: 9 digits + 1 check digit *)
      if calc_company_check_digit number <> String.sub number 9 1 then
        raise Invalid_checksum;
      number
  | 12 ->
      (* Personal INN: 10 digits + 2 check digits *)
      if calc_personal_check_digits number <> String.sub number 10 2 then
        raise Invalid_checksum;
      number
  | _ -> raise Invalid_length

let is_valid number =
  try
    ignore (validate number);
    true
  with Invalid_format | Invalid_length | Invalid_checksum -> false
