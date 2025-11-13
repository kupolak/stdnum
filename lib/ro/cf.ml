open Tools

exception Invalid_length
exception Invalid_format
exception Invalid_component
exception Invalid_checksum

let compact number =
  Utils.clean number "[ -]+" |> String.uppercase_ascii |> String.trim

(* For backwards compatibility with cui module *)
let calc_check_digit = Cui.calc_check_digit

let validate number =
  let number = compact number in
  let cnumber =
    if String.length number >= 2 && String.sub number 0 2 = "RO" then
      String.sub number 2 (String.length number - 2)
    else number
  in
  let len = String.length cnumber in

  try
    if len = 13 then
      (* CNP can also be used as VAT number *)
      let _ = Cnp.validate cnumber in
      number
    else if len >= 2 && len <= 10 then
      (* CUI/CIF validation *)
      let _ = Cui.validate number in
      number
    else raise Invalid_length
  with
  | Cnp.Invalid_format | Cui.Invalid_format -> raise Invalid_format
  | Cnp.Invalid_length | Cui.Invalid_length -> raise Invalid_length
  | Cnp.Invalid_component -> raise Invalid_component
  | Cnp.Invalid_checksum | Cui.Invalid_checksum -> raise Invalid_checksum

let is_valid number =
  try
    ignore (validate number);
    true
  with
  | Invalid_format | Invalid_length | Invalid_component | Invalid_checksum ->
    false
