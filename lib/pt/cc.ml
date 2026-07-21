(** CC (Número de Cartão de Cidadão, Portuguese Identity number).

    The Portuguese Identity Number is alphanumeric and consists of the numeric
    Número de Identificação Civil, a two-letter version and a check digit.

    More information:
    - https://pt.wikipedia.org/wiki/Cartão_de_cidadão
    - https://www.autenticacao.gov.pt/documents/20126/115760/Validação+de+Número+de+Documento+do+Cartão+de+Cidadão.pdf *)

open Tools

exception Invalid_format
exception Invalid_length
exception Invalid_checksum

let compact number =
  Utils.clean number " " |> String.uppercase_ascii |> String.trim

let char_value c =
  match c with
  | '0' .. '9' -> int_of_char c - int_of_char '0'
  | 'A' .. 'Z' -> int_of_char c - int_of_char 'A' + 10
  | _ -> -1

let is_cc_re number =
  let len = String.length number in
  if len < 3 then false
  else
    let check_digit = number.[len - 1] in
    let char1 = number.[len - 2] in
    let char2 = number.[len - 3] in
    let rec check_digits i =
      if i = len - 3 then true
      else match number.[i] with
           | '0' .. '9' -> check_digits (i + 1)
           | _ -> false
    in
    (match check_digit with '0' .. '9' -> true | _ -> false) && char_value char1 >= 0 && char_value char2 >= 0 && check_digits 0

let calc_check_digit number =
  let cutoff x = if x > 9 then x - 9 else x in
  let len = String.length number in
  let s = ref 0 in
  for i = 0 to len - 1 do
    let n = number.[len - 1 - i] in
    let v = char_value n in
    if i mod 2 = 0 then
      s := !s + cutoff (v * 2)
    else
      s := !s + v
  done;
  let rem = (10 - !s) mod 10 in
  let rem = if rem < 0 then rem + 10 else rem in
  string_of_int rem

let validate number =
  let number = compact number in
  if not (is_cc_re number) then raise Invalid_format;
  let base = String.sub number 0 (String.length number - 1) in
  let check = String.sub number (String.length number - 1) 1 in
  if calc_check_digit base <> check then raise Invalid_checksum;
  number

let is_valid number =
  try
    ignore (validate number);
    true
  with Invalid_format | Invalid_length | Invalid_checksum -> false

let format number =
  let number = compact number in
  let len = String.length number in
  if len >= 4 then
    String.sub number 0 (len - 4) ^ " " ^ String.sub number (len - 4) 1 ^ " " ^ String.sub number (len - 3) 3
  else number
