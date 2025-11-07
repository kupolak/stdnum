open Tools

exception Invalid_length
exception Invalid_format
exception Invalid_component
exception Invalid_checksum

let compact number = Utils.clean number "[ -]" |> String.trim

(* Use the same calc_check_digit function as PIN *)
let calc_check_digit = Pin.calc_check_digit

let validate number =
  let number = compact number in
  if String.length number <> 13 then raise Invalid_length;
  if not (Utils.is_digits number) then raise Invalid_format;
  if number.[0] <> '0' then raise Invalid_component;
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
  String.sub number 0 1 ^ "-" ^ String.sub number 1 2 ^ "-"
  ^ String.sub number 3 1 ^ "-" ^ String.sub number 4 3 ^ "-"
  ^ String.sub number 7 5 ^ "-" ^ String.sub number 12 1
