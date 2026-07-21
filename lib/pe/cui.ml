(** CUI (Cédula Única de Identidad, Peruvian identity number).

    The Cédula Única de Identidad (CUI) is the unique identifier for persons
    that appears on the Documento Nacional de Identidad (DNI), the national
    identity document of Peru. The number consists of 8 digits and an optional
    extra check digit.

    More information:
    - https://www.gob.pe/235-documento-nacional-de-identidad-dni
    - https://es.wikipedia.org/wiki/Documento_Nacional_de_Identidad_(Perú) *)

open Tools

exception Invalid_format
exception Invalid_length
exception Invalid_checksum

let compact number =
  Utils.clean number "[ -]" |> String.trim |> String.uppercase_ascii

let calc_check_digits number =
  let number = compact number in
  let weights = [| 3; 2; 7; 6; 5; 4; 3; 2 |] in
  let check = ref 0 in
  for i = 0 to 7 do
    check := !check + (weights.(i) * (int_of_char number.[i] - int_of_char '0'))
  done;
  let c = !check mod 11 in
  let s1 = "65432110987" in
  let s2 = "KJIHGFEDCBA" in
  String.make 1 s1.[c] ^ String.make 1 s2.[c]

let to_ruc number =
  let number = "10" ^ String.sub (compact number) 0 8 in
  number ^ Ruc.calc_check_digit number

let validate number =
  let number = compact number in
  let len = String.length number in
  if len <> 8 && len <> 9 then raise Invalid_length;
  if not (Utils.is_digits (String.sub number 0 8)) then raise Invalid_format;
  (if len > 8 then
     let valid_checks = calc_check_digits number in
     let check = String.make 1 number.[8] in
     if not (String.contains valid_checks check.[0]) then raise Invalid_checksum);
  number

let is_valid number =
  try
    ignore (validate number);
    true
  with Invalid_format | Invalid_length | Invalid_checksum -> false
