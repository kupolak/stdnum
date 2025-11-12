open Tools

exception Invalid_length
exception Invalid_format
exception Invalid_checksum
exception Invalid_component of string

let compact number = Nn.compact number

let validate number =
  let number = compact number in
  if (not (Utils.is_digits number)) || int_of_string number <= 0 then
    raise Invalid_format;
  if String.length number <> 11 then raise Invalid_length;

  (* BIS-specific validation: month must be in 20..32 or 40..52 range *)
  let month = int_of_string (String.sub number 2 2) in
  if not ((month >= 20 && month <= 32) || (month >= 40 && month <= 52)) then
    raise (Invalid_component "Month must be in 20..32 or 40..52 range");

  (* Check checksum using nn's logic, catch and re-raise exceptions *)
  (try
     let _ = Nn.get_birth_date_parts number in
     ()
   with
  | Nn.Invalid_checksum -> raise Invalid_checksum
  | Nn.Invalid_component _ ->
      () (* Ignore month validation from nn, we already checked *)
  | Nn.Invalid_format -> raise Invalid_format
  | Nn.Invalid_length -> raise Invalid_length);

  number

let is_valid number =
  try
    ignore (validate number);
    true
  with
  | Invalid_format | Invalid_length | Invalid_checksum | Invalid_component _ ->
    false

let format number = Nn.format number
let get_birth_year number = Nn.get_birth_year number
let get_birth_month number = Nn.get_birth_month number
let get_birth_date number = Nn.get_birth_date number

let get_gender number =
  let number = compact number in
  let month = int_of_string (String.sub number 2 2) in
  (* Gender is only known if the month was incremented with 40 *)
  if month >= 40 then Some (Nn.get_gender number) else None
