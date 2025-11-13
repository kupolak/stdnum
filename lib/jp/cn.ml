open Tools

exception Invalid_length
exception Invalid_format
exception Invalid_checksum

let compact number = Utils.clean number "[ -]" |> String.trim

let calc_check_digit number =
  (* Calculate check digit using weights (1, 2, 1, 2, ...) applied to digits in reverse order *)
  let weights = [| 1; 2; 1; 2; 1; 2; 1; 2; 1; 2; 1; 2 |] in
  let len = String.length number in
  let sum = ref 0 in
  for i = 0 to len - 1 do
    let digit = int_of_char number.[len - 1 - i] - int_of_char '0' in
    sum := !sum + (weights.(i) * digit)
  done;
  let check = 9 - (!sum mod 9) in
  string_of_int check

let format number =
  let number = compact number in
  Printf.sprintf "%s-%s-%s-%s" (String.sub number 0 1) (String.sub number 1 4)
    (String.sub number 5 4) (String.sub number 9 4)

let validate number =
  let number = compact number in

  if String.length number <> 13 then raise Invalid_length;

  if not (Utils.is_digits number) then raise Invalid_format;

  let check_digit = String.sub number 0 1 in
  let calculated_check = calc_check_digit (String.sub number 1 12) in
  if check_digit <> calculated_check then raise Invalid_checksum;

  number

let is_valid number =
  try
    ignore (validate number);
    true
  with Invalid_format | Invalid_length | Invalid_checksum -> false
