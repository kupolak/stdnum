(** CNPJ (Cadastro Nacional da Pessoa Jurídica, Brazilian company identifier).

    Numbers from the national register of legal entities have 14 alphanumeric
    digits. The first 8 digits identify the company, the following 4 digits
    identify a business unit and the last 2 digits are check digits.

    More information:
    - https://en.wikipedia.org/wiki/CNPJ *)

open Tools

exception Invalid_format
exception Invalid_length
exception Invalid_checksum

let compact number =
  Utils.clean number "[ -./]" |> String.trim |> String.uppercase_ascii

let calc_check_digits number =
  let number = compact number in
  let values = Array.init 12 (fun i -> int_of_char number.[i] - 48) in

  let weights1 = [| 5; 4; 3; 2; 9; 8; 7; 6; 5; 4; 3; 2 |] in
  let sum1 = ref 0 in
  for i = 0 to 11 do
    sum1 := !sum1 + (weights1.(i) * values.(i))
  done;
  let d1 = (11 - (!sum1 mod 11)) mod 10 in

  let values_w_d1 =
    Array.init 13 (fun i -> if i < 12 then values.(i) else d1)
  in
  let weights2 = [| 6; 5; 4; 3; 2; 9; 8; 7; 6; 5; 4; 3; 2 |] in
  let sum2 = ref 0 in
  for i = 0 to 12 do
    sum2 := !sum2 + (weights2.(i) * values_w_d1.(i))
  done;
  let d2 = (11 - (!sum2 mod 11)) mod 10 in

  string_of_int d1 ^ string_of_int d2

let validate number =
  let number = compact number in

  let is_valid_char c = (c >= '0' && c <= '9') || (c >= 'A' && c <= 'Z') in
  let all_valid =
    let rec check i =
      if i >= String.length number then true
      else if is_valid_char number.[i] then check (i + 1)
      else false
    in
    check 0
  in

  if (not all_valid) || String.starts_with ~prefix:"000000000000" number then
    raise Invalid_format;

  if String.length number <> 14 then raise Invalid_length;

  if calc_check_digits number <> String.sub number 12 2 then
    raise Invalid_checksum;

  number

let is_valid number =
  try
    ignore (validate number);
    true
  with Invalid_format | Invalid_length | Invalid_checksum -> false

let format number =
  let number = compact number in
  String.sub number 0 2 ^ "." ^ String.sub number 2 3 ^ "."
  ^ String.sub number 5 3 ^ "/" ^ String.sub number 8 4 ^ "-"
  ^ String.sub number 12 2
