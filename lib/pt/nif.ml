(** NIF (Número de identificação fiscal, Portuguese VAT number).

    The NIF (Número de identificação fiscal, NIPC, Número de Identificação de
    Pessoa Colectiva) is used for VAT purposes. It is a 9-digit number with a
    simple checksum. *)

open Tools

exception Invalid_format
exception Invalid_length
exception Invalid_checksum

let compact number =
  let number =
    Utils.clean number "[ -.]" |> String.uppercase_ascii |> String.trim
  in
  if String.starts_with ~prefix:"PT" number then
    String.sub number 2 (String.length number - 2)
  else number

let calc_check_digit number =
  let s = ref 0 in
  for i = 0 to String.length number - 1 do
    let n = int_of_char number.[i] - int_of_char '0' in
    s := !s + ((9 - i) * n)
  done;
  let rem = (11 - !s) mod 11 in
  let rem = if rem < 0 then rem + 11 else rem in
  let rem = rem mod 10 in
  string_of_int rem

let validate number =
  let number = compact number in
  if
    (not (Utils.is_digits number))
    || (String.length number > 0 && number.[0] = '0')
  then raise Invalid_format;
  if String.length number <> 9 then raise Invalid_length;
  let base = String.sub number 0 8 in
  let check = String.sub number 8 1 in
  if calc_check_digit base <> check then raise Invalid_checksum;
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
