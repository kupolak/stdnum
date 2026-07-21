(** NIT (Número de Identificación Tributaria, Guatemala tax number).

    The Número de Identificación Tributaria (NIT) is an identifier of legal
    entities for tax purposes in Guatemala.

    The number consists of 2 to 12 characters, where the last one is the check
    digit (a digit or the letter K) and the rest are digits. Leading zeroes are
    usually omitted. Digits and check digit are usually separated with a hyphen.

    More information:
    - https://portal.sat.gob.gt/portal/descarga/6524/factura-electronica-fel/25542/fel-reglas-y-validaciones.pdf
      (page 58)
    - https://portal.sat.gob.gt/portal/consulta-cui-nit/ *)

open Tools

exception Invalid_format
exception Invalid_length
exception Invalid_checksum

let rec remove_leading_zeros s =
  if String.length s > 0 && s.[0] = '0' then
    remove_leading_zeros (String.sub s 1 (String.length s - 1))
  else s

let compact number =
  Utils.clean number "[ -]" |> String.trim |> String.uppercase_ascii
  |> remove_leading_zeros

let calc_check_digit number =
  let c = ref 0 in
  let len = String.length number in
  for i = 0 to len - 1 do
    let n = int_of_char number.[i] - int_of_char '0' in
    let multiplier = len + 1 - i in
    c := !c + (multiplier * n)
  done;
  let result = - !c mod 11 in
  let result = if result < 0 then result + 11 else result in
  if result = 10 then "K" else string_of_int result

let validate number =
  let number = compact number in
  let len = String.length number in
  if len < 2 || len > 12 then raise Invalid_length;
  let body = String.sub number 0 (len - 1) in
  let check = String.sub number (len - 1) 1 in
  if not (Utils.is_digits body) then raise Invalid_format;
  if check <> "K" && not (Utils.is_digits check) then raise Invalid_format;
  if check <> calc_check_digit body then raise Invalid_checksum;
  number

let validate_result number =
  try Ok (validate number) with
  | Invalid_format -> Error Error.Invalid_format
  | Invalid_length -> Error Error.Invalid_length
  | Invalid_checksum -> Error Error.Invalid_checksum

let is_valid number =
  try
    ignore (validate number);
    true
  with Invalid_format | Invalid_length | Invalid_checksum -> false

let format number =
  let number = compact number in
  let len = String.length number in
  String.sub number 0 (len - 1) ^ "-" ^ String.sub number (len - 1) 1
