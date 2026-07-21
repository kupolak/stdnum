open Tools

exception Invalid_length
exception Invalid_format
exception Invalid_component
exception Invalid_checksum

let compact number = Utils.clean number "[ -.]" |> String.trim

let calc_check_digit number =
  let weights = [| 31; 29; 23; 19; 17; 13; 7; 5; 3 |] in
  let total = ref 0 in
  for i = 0 to 8 do
    let digit = int_of_char number.[i] - int_of_char '0' in
    total := !total + (weights.(i) * digit)
  done;
  string_of_int (10 - (!total mod 11))

let validate number =
  let number = compact number in
  let len = String.length number in
  if len <> 10 && len <> 13 then raise Invalid_length;
  if not (Utils.is_digits number) then raise Invalid_format;
  (* Check if digits 2-8 are all zeros *)
  let middle_part = String.sub number 2 7 in
  if middle_part = "0000000" then raise Invalid_component;
  (* Check if last 3 digits are 000 for 13-digit numbers *)
  if len = 13 && String.sub number 10 3 = "000" then raise Invalid_component;
  (* Check the check digit *)
  let calculated_check_digit = calc_check_digit number in
  if String.get number 9 <> String.get calculated_check_digit 0 then
    raise Invalid_checksum;
  number

let validate_result number =
  try Ok (validate number) with
  | Invalid_length -> Error Error.Invalid_length
  | Invalid_format -> Error Error.Invalid_format
  | Invalid_component -> Error Tools.Error.Invalid_component
  | Invalid_checksum -> Error Error.Invalid_checksum

let is_valid number = Result.is_ok (validate_result number)

let format number =
  let number = compact number in
  if String.length number = 10 then number
  else if String.length number = 13 then
    String.sub number 0 10 ^ "-" ^ String.sub number 10 3
  else number
