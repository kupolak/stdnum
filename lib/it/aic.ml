(** AIC (Italian code for identification of drugs).

    AIC codes are used to identify drugs allowed to be sold in Italy. Codes are
    issued by the Italian Drugs Agency (AIFA, Agenzia Italiana del Farmaco), the
    government authority responsible for drugs regulation in Italy.

    The number consists of 9 digits and includes a check digit.

    More information:
    - https://www.gazzettaufficiale.it/do/atto/serie_generale/caricaPdf?cdimg=14A0566800100010110001&dgu=2014-07-18&art.dataPubblicazioneGazzetta=2014-07-18&art.codiceRedazionale=14A05668&art.num=1&art.tiposerie=SG *)

open Tools

exception Invalid_format
exception Invalid_length
exception Invalid_checksum
exception Invalid_component

(* The table of AIC BASE32 allowed chars *)
let base32_alphabet = "0123456789BCDFGHJKLMNPQRSTUVWXYZ"

let compact number =
  Utils.clean number "[ ]" |> String.uppercase_ascii |> String.trim

let from_base32 number =
  let number = compact number in
  (* Check if all characters are valid BASE32 *)
  if not (String.for_all (fun c -> String.contains base32_alphabet c) number)
  then raise Invalid_format;
  (* Convert BASE32 to BASE10 *)
  let len = String.length number in
  let sum = ref 0 in
  for i = 0 to len - 1 do
    let c = number.[len - 1 - i] in
    let index = String.index base32_alphabet c in
    sum := !sum + (index * int_of_float (32.0 ** float_of_int i))
  done;
  (* Pad to 9 digits *)
  Printf.sprintf "%09d" !sum

let to_base32 number =
  let number = compact number in
  if not (Utils.is_digits number) then raise Invalid_format;
  let remainder = ref (int_of_string number) in
  let res = ref "" in
  while !remainder > 31 do
    res := String.make 1 base32_alphabet.[!remainder mod 32] ^ !res;
    remainder := !remainder / 32
  done;
  res := String.make 1 base32_alphabet.[!remainder] ^ !res;
  (* Pad to 6 characters *)
  let len = String.length !res in
  if len < 6 then String.make (6 - len) '0' ^ !res else !res

let calc_check_digit number =
  let number = compact number in
  let weights = [ 1; 2; 1; 2; 1; 2; 1; 2 ] in
  let number_list =
    List.map (fun x -> int_of_char x - 48) (List.of_seq (String.to_seq number))
  in
  let sum =
    List.fold_left2
      (fun acc w n ->
        let x = w * n in
        acc + (x / 10) + (x mod 10))
      0 weights number_list
  in
  string_of_int (sum mod 10)

let validate_base10 number =
  let number = compact number in
  if String.length number <> 9 then raise Invalid_length;
  if not (Utils.is_digits number) then raise Invalid_format;
  if number.[0] <> '0' then raise Invalid_component;
  if calc_check_digit (String.sub number 0 8) <> String.make 1 number.[8] then
    raise Invalid_checksum;
  number

let validate_base32 number =
  let number = compact number in
  if String.length number <> 6 then raise Invalid_length;
  validate_base10 (from_base32 number)

let validate number =
  let number = compact number in
  if String.length number = 6 then validate_base32 number
  else validate_base10 number

let is_valid number =
  try
    ignore (validate number);
    true
  with
  | Invalid_format | Invalid_length | Invalid_checksum | Invalid_component ->
    false
