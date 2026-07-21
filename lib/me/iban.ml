(** Montenegro IBAN (International Bank Account Number).

    The IBAN is used to identify bank accounts across national borders. The
    Montenegro IBAN is built up of the IBAN prefix (ME) and check digits,
    followed by a 3 digit bank identifier, a 13 digit account number and 2 more
    check digits. *)

exception Invalid_format
exception Invalid_length
exception Invalid_checksum
exception Invalid_component

let compact number = Stdnum.Iban.compact number

let format number = Stdnum.Iban.format number

let checksum number =
  let rec mod97 acc s =
    if String.length s = 0 then acc
    else
      let len = min 9 (String.length s) in
      let chunk = String.sub s 0 len in
      let rest = String.sub s len (String.length s - len) in
      let num = int_of_string (string_of_int acc ^ chunk) in
      mod97 (num mod 97) rest
  in
  mod97 0 number

let validate number =
  let number = 
    try Stdnum.Iban.validate ~check_country:false number
    with Stdnum.Iban.Invalid_format -> raise Invalid_format
       | Stdnum.Iban.Invalid_length -> raise Invalid_length
       | Stdnum.Iban.Invalid_checksum -> raise Invalid_checksum
       | Stdnum.Iban.Invalid_component -> raise Invalid_component
  in
  if not (String.starts_with ~prefix:"ME" number) then raise Invalid_component;
  let numeric_part = String.sub number 4 (String.length number - 4) in
  if checksum numeric_part <> 1 then raise Invalid_checksum;
  number

let is_valid number =
  try
    ignore (validate number);
    true
  with Invalid_format | Invalid_length | Invalid_checksum | Invalid_component -> false
