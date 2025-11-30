open Tools

exception Invalid_checksum
exception Invalid_length
exception Invalid_format

let compact number = Utils.clean number "[ .]" |> String.trim

let validate number =
  let number = compact number in

  (* Check all digits *)
  if not (Utils.is_digits number) then raise Invalid_format;

  (* Check length *)
  if String.length number <> 14 then raise Invalid_length;

  (* La Poste SIRET (except the head office) do not use the Luhn checksum
     but the sum of digits must be a multiple of 5 *)
  (if
     String.length number >= 9
     && String.sub number 0 9 = "356000000"
     && number <> "35600000000048"
   then (
     (* Sum all digits and check if divisible by 5 *)
     let sum = ref 0 in
     for i = 0 to String.length number - 1 do
       sum := !sum + (int_of_char number.[i] - int_of_char '0')
     done;
     if !sum mod 5 <> 0 then raise Invalid_checksum)
   else
     (* Standard Luhn validation *)
     try ignore (Luhn.validate number)
     with Luhn.Invalid_checksum -> raise Invalid_checksum);

  (* Validate the SIREN part (first 9 digits) *)
  let siren_part = String.sub number 0 9 in
  (try ignore (Siren.validate siren_part) with
  | Siren.Invalid_checksum -> raise Invalid_checksum
  | Siren.Invalid_format -> raise Invalid_format
  | Siren.Invalid_length -> raise Invalid_length);

  number

let is_valid number =
  try
    ignore (validate number);
    true
  with Invalid_checksum | Invalid_length | Invalid_format -> false

let to_siren number =
  (* Extract first 9 digits, preserving separators if present *)
  let result = ref [] in
  let digit_count = ref 0 in
  let i = ref 0 in
  while !digit_count < 9 && !i < String.length number do
    let char = number.[!i] in
    result := char :: !result;
    if Utils.is_digits (String.make 1 char) then incr digit_count;
    incr i
  done;
  String.of_seq (List.rev !result |> List.to_seq)

let to_tva number = Siren.to_tva (to_siren number)

let format ?(separator = " ") number =
  let number = compact number in
  let part1 = String.sub number 0 3 in
  let part2 = String.sub number 3 3 in
  let part3 = String.sub number 6 3 in
  let part4 = String.sub number 9 5 in
  String.concat separator [ part1; part2; part3; part4 ]
