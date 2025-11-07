open Tools

exception Invalid_length
exception Invalid_format
exception Invalid_component
exception Invalid_checksum

let compact number = Utils.clean number "[ -]" |> String.trim

let calc_check_digit number =
  let sum = ref 0 in
  for i = 0 to 11 do
    let digit = int_of_char number.[i] - int_of_char '0' in
    sum := !sum + ((13 - i) * digit)
  done;
  string_of_int ((11 - (!sum mod 11)) mod 10)

let validate number =
  let number = compact number in
  if String.length number <> 13 then raise Invalid_length;
  if not (Utils.is_digits number) then raise Invalid_format;
  if number.[0] = '0' || number.[0] = '9' then raise Invalid_component;
  if String.make 1 number.[12] <> calc_check_digit number then
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
  String.sub number 0 1 ^ "-" ^ String.sub number 1 4 ^ "-"
  ^ String.sub number 5 5 ^ "-" ^ String.sub number 10 2 ^ "-"
  ^ String.sub number 12 1
