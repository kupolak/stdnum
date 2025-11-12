open Tools

exception Invalid_length
exception Invalid_format
exception Invalid_checksum

let compact number =
  let number =
    Utils.clean number "[ -]" |> String.uppercase_ascii |> String.trim
  in
  if String.length number >= 2 && String.sub number 0 2 = "ES" then
    String.sub number 2 (String.length number - 2)
  else number

let validate number =
  let number = compact number in
  if String.length number <> 9 then raise Invalid_length;

  (* Check that middle characters (positions 1-7) are digits *)
  let middle = String.sub number 1 7 in
  if not (Utils.is_digits middle) then raise Invalid_format;

  let first_char = number.[0] in
  let last_char = number.[8] in

  (if first_char = 'K' || first_char = 'L' || first_char = 'M' then (
     (* K: Spanish younger than 14 year old
        L: Spanish living outside Spain without DNI
        M: granted the tax to foreigners who have no NIE
        These use the old checkdigit algorithm (the DNI one) *)
     let check_digits = String.sub number 1 7 in
     let calculated = Dni.calc_check_digit check_digits in
     let provided = String.make 1 last_char in
     if calculated <> provided then raise Invalid_checksum)
   else if first_char >= '0' && first_char <= '9' then
     (* Natural resident - validate as DNI *)
     try ignore (Dni.validate number) with
     | Dni.Invalid_checksum -> raise Invalid_checksum
     | Dni.Invalid_format -> raise Invalid_format
     | Dni.Invalid_length -> raise Invalid_length
   else if first_char = 'X' || first_char = 'Y' || first_char = 'Z' then
     (* Foreign natural person - validate as NIE *)
     try ignore (Nie.validate number) with
     | Nie.Invalid_checksum -> raise Invalid_checksum
     | Nie.Invalid_format -> raise Invalid_format
     | Nie.Invalid_length -> raise Invalid_length
   else
     (* Otherwise it has to be a valid CIF *)
     try ignore (Cif.validate number) with
     | Cif.Invalid_checksum -> raise Invalid_checksum
     | Cif.Invalid_format -> raise Invalid_format
     | Cif.Invalid_length -> raise Invalid_length);

  number

let is_valid number =
  try
    ignore (validate number);
    true
  with Invalid_format | Invalid_length | Invalid_checksum -> false
