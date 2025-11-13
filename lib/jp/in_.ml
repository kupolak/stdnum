open Tools

exception Invalid_length
exception Invalid_format
exception Invalid_checksum

let compact number = Utils.clean number "[ -]" |> String.trim

let calc_check_digit number =
  (* Calculate check digit using weights (6, 5, 4, 3, 2, 7, 6, 5, 4, 3, 2) *)
  let weights = [| 6; 5; 4; 3; 2; 7; 6; 5; 4; 3; 2 |] in
  let sum = ref 0 in
  for i = 0 to 10 do
    let digit = int_of_char number.[i] - int_of_char '0' in
    sum := !sum + (weights.(i) * digit)
  done;
  (* Check digit = (-sum % 11) % 10, equivalent to (11 - (sum % 11)) % 10 in OCaml *)
  let check = (11 - (!sum mod 11)) mod 10 in
  string_of_int check

let format number =
  let number = compact number in
  Printf.sprintf "%s %s %s" (String.sub number 0 4) (String.sub number 4 4)
    (String.sub number 8 4)

let validate number =
  let number = compact number in

  if String.length number <> 12 then raise Invalid_length;

  if not (Utils.is_digits number) then raise Invalid_format;

  let check_digit = String.sub number 11 1 in
  let calculated_check = calc_check_digit (String.sub number 0 11) in
  if check_digit <> calculated_check then raise Invalid_checksum;

  number

let is_valid number =
  try
    ignore (validate number);
    true
  with Invalid_format | Invalid_length | Invalid_checksum -> false
