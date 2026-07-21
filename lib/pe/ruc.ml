(** RUC (Registro Único de Contribuyentes, Peruvian company tax number).

    The RUC (Registro Único de Contribuyentes) is the tax number of Peru
    assigned to legal and natural persons. The number consists of 11 digits, the
    first two indicate the kind of number, for personal numbers it is followed
    by the DNI and a check digit.

    More information:
    - https://www.sunat.gob.pe/legislacion/ruc/
    - https://consultarelruc.pe/ *)

open Tools

exception Invalid_format
exception Invalid_length
exception Invalid_checksum
exception Invalid_component

let compact number = Utils.clean number " " |> String.trim

let calc_check_digit number =
  let weights = [| 5; 4; 3; 2; 7; 6; 5; 4; 3; 2 |] in
  let check = ref 0 in
  for i = 0 to 9 do
    check := !check + (weights.(i) * (int_of_char number.[i] - int_of_char '0'))
  done;
  string_of_int ((11 - (!check mod 11)) mod 10)

let validate number =
  let number = compact number in
  if String.length number <> 11 then raise Invalid_length;
  if not (Utils.is_digits number) then raise Invalid_format;
  let prefix = String.sub number 0 2 in
  if prefix <> "10" && prefix <> "15" && prefix <> "17" && prefix <> "20" then
    raise Invalid_component;
  if String.make 1 number.[10] <> calc_check_digit (String.sub number 0 10) then
    raise Invalid_checksum;
  number

let is_valid number =
  try
    ignore (validate number);
    true
  with
  | Invalid_format | Invalid_length | Invalid_checksum | Invalid_component ->
    false

let to_dni number =
  let number = validate number in
  if not (String.starts_with ~prefix:"10" number) then raise Invalid_component;
  String.sub number 2 8
