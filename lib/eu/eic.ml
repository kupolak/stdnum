(** EIC (European Energy Identification Code).

    The EIC (Energy Identification Code) a 16 character code used in Europe to
    uniquely identify entities and objects in the electricity and gas sector.

    The number uses letters, digits and the minus sign. The first 2 character
    identify the issuing office, 1 character for the object type, 12 digits for
    the object and 1 check character.

    More information:
    - https://en.wikipedia.org/wiki/Energy_Identification_Code
    - https://www.entsoe.eu/data/energy-identification-codes-eic/ *)

open Tools

exception Invalid_format
exception Invalid_length
exception Invalid_checksum

let alphabet = "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ-"

let index_of c =
  match String.index_opt alphabet c with
  | Some i -> i
  | None -> raise Invalid_format

let compact number =
  Utils.clean number " " |> String.trim

let calc_check_digit number =
  let number = compact number in
  let sum = ref 0 in
  for i = 0 to 14 do
    let n = index_of number.[i] in
    sum := !sum + ((16 - i) * n)
  done;
  let rem = (!sum - 1) mod 37 in
  let rem = if rem < 0 then rem + 37 else rem in
  String.make 1 alphabet.[36 - rem]

let validate number =
  let number = compact number in
  if String.length number <> 16 then raise Invalid_length;
  String.iter (fun c -> ignore (index_of c)) number;
  if number.[15] = '-' then raise Invalid_format;
  if String.sub number 15 1 <> calc_check_digit number then raise Invalid_checksum;
  number

let is_valid number =
  try
    ignore (validate number);
    true
  with Invalid_format | Invalid_length | Invalid_checksum -> false
