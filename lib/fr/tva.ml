open Tools

exception Invalid_checksum
exception Invalid_length
exception Invalid_format
exception Invalid_component

(* Valid characters for the first two digits (O and I are missing) *)
let alphabet = "0123456789ABCDEFGHJKLMNPQRSTUVWXYZ"

let compact number =
  let number =
    Utils.clean number "[ .-]" |> String.uppercase_ascii |> String.trim
  in
  (* Remove FR prefix if present *)
  if String.length number >= 2 && String.sub number 0 2 = "FR" then
    String.sub number 2 (String.length number - 2)
  else number

let validate number =
  let number = compact number in

  (* Check length *)
  if String.length number <> 11 then raise Invalid_length;

  (* Check first two characters are in valid alphabet *)
  let char_in_alphabet c =
    try
      ignore (String.index alphabet c);
      true
    with Not_found -> false
  in

  if not (char_in_alphabet number.[0] && char_in_alphabet number.[1]) then
    raise Invalid_format;

  (* Check last 9 characters are digits *)
  let siren_part = String.sub number 2 9 in
  if not (Utils.is_digits siren_part) then raise Invalid_format;

  (* Validate SIREN part (unless Monaco VAT which starts with 000) *)
  (if String.sub siren_part 0 3 <> "000" then
     try ignore (Siren.validate siren_part) with
     | Siren.Invalid_checksum -> raise Invalid_checksum
     | Siren.Invalid_format -> raise Invalid_format
     | Siren.Invalid_length -> raise Invalid_length);

  (* Validate checksum *)
  let first_two = String.sub number 0 2 in
  (if Utils.is_digits first_two then (
     (* All-numeric old style *)
     let check = int_of_string first_two in
     let siren_int = int_of_string siren_part in
     let expected = ((siren_int * 100) + 12) mod 97 in
     if check <> expected then raise Invalid_checksum)
   else
     (* New style with at least one letter *)
     let char_index c = try String.index alphabet c with Not_found -> 0 in
     let check =
       if Utils.is_digits (String.make 1 number.[0]) then
         (* First char is digit, second is letter *)
         (char_index number.[0] * 24) + char_index number.[1] - 10
       else
         (* First char is letter *)
         (char_index number.[0] * 34) + char_index number.[1] - 100
     in
     let siren_int = int_of_string siren_part in
     if (siren_int + 1 + (check / 11)) mod 11 <> check mod 11 then
       raise Invalid_checksum);

  number

let is_valid number =
  try
    ignore (validate number);
    true
  with
  | Invalid_checksum | Invalid_length | Invalid_format | Invalid_component ->
    false

let to_siren number =
  let number = compact number in
  let siren_part = String.sub number 2 9 in
  (* Check if Monaco VAT (cannot be converted to SIREN) *)
  if String.sub siren_part 0 3 = "000" then raise Invalid_component;
  siren_part
