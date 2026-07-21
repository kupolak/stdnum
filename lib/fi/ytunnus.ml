(** Y-tunnus (Finnish business identifier).

    The number is an 8-digit code with a weighted checksum. *)

exception Invalid_format
exception Invalid_length
exception Invalid_checksum

let compact number = Alv.compact number

let validate number =
  try Alv.validate number with
  | Alv.Invalid_format -> raise Invalid_format
  | Alv.Invalid_length -> raise Invalid_length
  | Alv.Invalid_checksum -> raise Invalid_checksum

let validate_result number =
  try Ok (validate number) with
  | Invalid_format -> Error Tools.Error.Invalid_format
  | Invalid_length -> Error Tools.Error.Invalid_length
  | Invalid_checksum -> Error Tools.Error.Invalid_checksum

let is_valid number =
  try
    ignore (validate number);
    true
  with Invalid_format | Invalid_length | Invalid_checksum -> false

let format number =
  let number = compact number in
  String.sub number 0 7 ^ "-" ^ String.sub number 7 1
