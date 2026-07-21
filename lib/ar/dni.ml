(** DNI (Documento Nacional de Identidad, Argentinian national identity nr.).

    The DNI number is the number that appears on the Argentinian national
    identity document and is used to identify citizen and foreigners residing in
    the country.

    More information:
    - https://en.wikipedia.org/wiki/Documento_Nacional_de_Identidad_(Argentina)
*)

open Tools

exception Invalid_format
exception Invalid_length

let compact number = Utils.clean number "[ .]" |> String.trim

let validate number =
  let number = compact number in
  if not (Utils.is_digits number) then raise Invalid_format;
  let len = String.length number in
  if len <> 7 && len <> 8 then raise Invalid_length;
  number

let validate_result number =
  try Ok (validate number) with
  | Invalid_format -> Error Error.Invalid_format
  | Invalid_length -> Error Error.Invalid_length

let is_valid number =
  try
    ignore (validate number);
    true
  with Invalid_format | Invalid_length -> false

let format number =
  let number = compact number in
  let len = String.length number in
  String.sub number 0 (len - 6)
  ^ "."
  ^ String.sub number (len - 6) 3
  ^ "."
  ^ String.sub number (len - 3) 3
