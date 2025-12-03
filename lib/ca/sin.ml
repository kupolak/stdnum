open Tools

exception Invalid_format
exception Invalid_length
exception Invalid_checksum
exception Invalid_component

let compact number =
  (* Remove dashes and spaces *)
  Utils.clean number "[ -]" |> String.trim

let validate number =
  let number = compact number in

  (* Check length: must be exactly 9 digits *)
  if String.length number <> 9 then raise Invalid_length;

  (* Check if all characters are digits *)
  if not (Utils.is_digits number) then raise Invalid_format;

  (* Check if first digit is valid (cannot be 0 or 8) *)
  if number.[0] = '0' || number.[0] = '8' then raise Invalid_component;

  (* Validate using Luhn algorithm *)
  (try ignore (Luhn.validate number)
   with Luhn.Invalid_checksum -> raise Invalid_checksum);

  number

let is_valid number =
  try
    ignore (validate number);
    true
  with
  | Invalid_format | Invalid_length | Invalid_checksum | Invalid_component ->
    false

let format number =
  let number = compact number in
  (* Format as XXX-XXX-XXX *)
  if String.length number = 9 then
    String.sub number 0 3 ^ "-" ^ String.sub number 3 3 ^ "-"
    ^ String.sub number 6 3
  else number
