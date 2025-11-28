open Tools

exception Invalid_component
exception Invalid_checksum
exception Invalid_length
exception Invalid_format

(* IBAN lengths by country code *)
let iban_lengths =
  [
    ("AD", 24)
  ; ("AE", 23)
  ; ("AL", 28)
  ; ("AT", 20)
  ; ("AZ", 28)
  ; ("BA", 20)
  ; ("BE", 16)
  ; ("BG", 22)
  ; ("BH", 22)
  ; ("BR", 29)
  ; ("BY", 28)
  ; ("CH", 21)
  ; ("CR", 22)
  ; ("CY", 28)
  ; ("CZ", 24)
  ; ("DE", 22)
  ; ("DK", 18)
  ; ("DO", 28)
  ; ("EE", 20)
  ; ("EG", 29)
  ; ("ES", 24)
  ; ("FI", 18)
  ; ("FO", 18)
  ; ("FR", 27)
  ; ("GB", 22)
  ; ("GE", 22)
  ; ("GI", 23)
  ; ("GL", 18)
  ; ("GR", 27)
  ; ("GT", 28)
  ; ("HR", 21)
  ; ("HU", 28)
  ; ("IE", 22)
  ; ("IL", 23)
  ; ("IS", 26)
  ; ("IT", 27)
  ; ("JO", 30)
  ; ("KW", 30)
  ; ("KZ", 20)
  ; ("LB", 28)
  ; ("LC", 32)
  ; ("LI", 21)
  ; ("LT", 20)
  ; ("LU", 20)
  ; ("LV", 21)
  ; ("MC", 27)
  ; ("MD", 24)
  ; ("ME", 22)
  ; ("MK", 19)
  ; ("MR", 27)
  ; ("MT", 31)
  ; ("MU", 30)
  ; ("NL", 18)
  ; ("NO", 15)
  ; ("PK", 24)
  ; ("PL", 28)
  ; ("PS", 29)
  ; ("PT", 25)
  ; ("QA", 29)
  ; ("RO", 24)
  ; ("RS", 22)
  ; ("SA", 24)
  ; ("SE", 24)
  ; ("SI", 19)
  ; ("SK", 24)
  ; ("SM", 27)
  ; ("TL", 23)
  ; ("TN", 24)
  ; ("TR", 26)
  ; ("UA", 29)
  ; ("VA", 22)
  ; ("VG", 24)
  ; ("XK", 20)
  ]

(* BBAN structure patterns by country code
   Format: (country_code, [(char_type, count); ...])
   where char_type is 'n' for numeric, 'a' for alpha, 'c' for alphanumeric *)
type char_type = Numeric | Alpha | Alphanumeric

let bban_structures =
  [
    ("AD", [ (Numeric, 8); (Alphanumeric, 12) ])
  ; ("AE", [ (Numeric, 19) ])
  ; ("AL", [ (Numeric, 8); (Alphanumeric, 16) ])
  ; ("AT", [ (Numeric, 16) ])
  ; ("AZ", [ (Alpha, 4); (Numeric, 20) ])
  ; ("BA", [ (Numeric, 16) ])
  ; ("BE", [ (Numeric, 12) ])
  ; ("BG", [ (Alpha, 4); (Numeric, 6); (Alphanumeric, 8) ])
  ; ("BH", [ (Alpha, 4); (Alphanumeric, 14) ])
  ; ("BR", [ (Numeric, 23); (Alpha, 1); (Alphanumeric, 1) ])
  ; ("BY", [ (Alpha, 4); (Numeric, 4); (Alphanumeric, 16) ])
  ; ("CH", [ (Numeric, 5); (Alphanumeric, 12) ])
  ; ("CR", [ (Numeric, 18) ])
  ; ("CY", [ (Numeric, 8); (Alphanumeric, 16) ])
  ; ("CZ", [ (Numeric, 20) ])
  ; ("DE", [ (Numeric, 18) ])
  ; ("DK", [ (Numeric, 14) ])
  ; ("DO", [ (Alpha, 4); (Numeric, 20) ])
  ; ("EE", [ (Numeric, 16) ])
  ; ("EG", [ (Numeric, 25) ])
  ; ("ES", [ (Numeric, 20) ])
  ; ("FI", [ (Numeric, 14) ])
  ; ("FO", [ (Numeric, 14) ])
  ; ("FR", [ (Numeric, 10); (Alphanumeric, 11); (Numeric, 2) ])
  ; ("GB", [ (Alpha, 4); (Numeric, 14) ])
  ; ("GE", [ (Alpha, 2); (Numeric, 16) ])
  ; ("GI", [ (Alpha, 4); (Alphanumeric, 15) ])
  ; ("GL", [ (Numeric, 14) ])
  ; ("GR", [ (Numeric, 7); (Alphanumeric, 16) ])
  ; ("GT", [ (Alphanumeric, 24) ])
  ; ("HR", [ (Numeric, 17) ])
  ; ("HU", [ (Numeric, 24) ])
  ; ("IE", [ (Alpha, 4); (Numeric, 14) ])
  ; ("IL", [ (Numeric, 19) ])
  ; ("IS", [ (Numeric, 22) ])
  ; ("IT", [ (Alpha, 1); (Numeric, 10); (Alphanumeric, 12) ])
  ; ("JO", [ (Alpha, 4); (Numeric, 4); (Alphanumeric, 18) ])
  ; ("KW", [ (Alpha, 4); (Alphanumeric, 22) ])
  ; ("KZ", [ (Numeric, 3); (Alphanumeric, 13) ])
  ; ("LB", [ (Numeric, 4); (Alphanumeric, 20) ])
  ; ("LC", [ (Alpha, 4); (Alphanumeric, 24) ])
  ; ("LI", [ (Numeric, 5); (Alphanumeric, 12) ])
  ; ("LT", [ (Numeric, 16) ])
  ; ("LU", [ (Numeric, 3); (Alphanumeric, 13) ])
  ; ("LV", [ (Alpha, 4); (Alphanumeric, 13) ])
  ; ("MC", [ (Numeric, 10); (Alphanumeric, 11); (Numeric, 2) ])
  ; ("MD", [ (Alphanumeric, 20) ])
  ; ("ME", [ (Numeric, 18) ])
  ; ("MK", [ (Numeric, 3); (Alphanumeric, 10); (Numeric, 2) ])
  ; ("MR", [ (Numeric, 23) ])
  ; ("MT", [ (Alpha, 4); (Numeric, 5); (Alphanumeric, 18) ])
  ; ("MU", [ (Alpha, 4); (Numeric, 19); (Alpha, 3) ])
  ; ("NL", [ (Alpha, 4); (Numeric, 10) ])
  ; ("NO", [ (Numeric, 11) ])
  ; ("PK", [ (Alpha, 4); (Alphanumeric, 16) ])
  ; ("PL", [ (Numeric, 24) ])
  ; ("PS", [ (Alpha, 4); (Alphanumeric, 21) ])
  ; ("PT", [ (Numeric, 21) ])
  ; ("QA", [ (Alpha, 4); (Alphanumeric, 21) ])
  ; ("RO", [ (Alpha, 4); (Alphanumeric, 16) ])
  ; ("RS", [ (Numeric, 18) ])
  ; ("SA", [ (Numeric, 2); (Alphanumeric, 18) ])
  ; ("SE", [ (Numeric, 20) ])
  ; ("SI", [ (Numeric, 15) ])
  ; ("SK", [ (Numeric, 20) ])
  ; ("SM", [ (Alpha, 1); (Numeric, 10); (Alphanumeric, 12) ])
  ; ("TL", [ (Numeric, 19) ])
  ; ("TN", [ (Numeric, 20) ])
  ; ("TR", [ (Numeric, 5); (Alphanumeric, 17) ])
  ; ("UA", [ (Numeric, 6); (Alphanumeric, 19) ])
  ; ("VA", [ (Numeric, 18) ])
  ; ("VG", [ (Alpha, 4); (Numeric, 16) ])
  ; ("XK", [ (Numeric, 16) ])
  ]

let check_char_type c char_type =
  match char_type with
  | Numeric -> c >= '0' && c <= '9'
  | Alpha -> c >= 'A' && c <= 'Z'
  | Alphanumeric -> (c >= '0' && c <= '9') || (c >= 'A' && c <= 'Z')

let validate_bban_structure bban structure =
  let rec validate_parts str pos parts =
    match parts with
    | [] -> pos = String.length str
    | (char_type, count) :: rest ->
        if pos + count > String.length str then false
        else
          let segment = String.sub str pos count in
          let valid = ref true in
          for i = 0 to count - 1 do
            if not (check_char_type segment.[i] char_type) then valid := false
          done;
          if !valid then validate_parts str (pos + count) rest else false
  in
  validate_parts bban 0 structure

let compact number =
  Utils.clean number "[ .-]" |> String.uppercase_ascii |> String.trim

let calc_check_digits number =
  let number = compact number in
  let number_without_check =
    String.sub number 0 2 ^ "00" ^ String.sub number 4 (String.length number - 4)
  in
  let checksum =
    Iso7064.Mod_97_10.checksum
      (String.sub number_without_check 4 (String.length number_without_check - 4)
      ^ String.sub number_without_check 0 4)
  in
  Printf.sprintf "%02d" (98 - checksum)

let validate ?(check_country = true) number =
  let number = compact number in

  (* Check minimum length *)
  if String.length number < 4 then raise Invalid_length;

  (* Check that first two characters are letters (country code) *)
  let cc = String.sub number 0 2 in
  if not (Utils.is_alpha cc) then raise Invalid_component;

  (* Check that next two characters are digits (check digits) *)
  let check_digits = String.sub number 2 2 in
  if not (Utils.is_digits check_digits) then raise Invalid_format;

  (* Check country code is known *)
  let expected_length =
    try List.assoc cc iban_lengths with Not_found -> raise Invalid_component
  in

  (* Check length matches country *)
  if String.length number <> expected_length then raise Invalid_length;

  (* Validate mod 97 checksum *)
  (try
     ignore
       (Iso7064.Mod_97_10.validate
          (String.sub number 4 (String.length number - 4)
          ^ String.sub number 0 4))
   with
  | Iso7064.Mod_97_10.Invalid_checksum -> raise Invalid_checksum
  | Iso7064.Mod_97_10.Invalid_format -> raise Invalid_format);

  (* Check BBAN structure if available *)
  let bban = String.sub number 4 (String.length number - 4) in
  (try
     let structure = List.assoc cc bban_structures in
     if not (validate_bban_structure bban structure) then raise Invalid_format
   with Not_found -> ());

  (* Country-specific validation *)
  (if check_country then
     match String.lowercase_ascii cc with
     | "es" -> (
         try ignore (Es.Iban.validate number) with
         | Es.Iban.Invalid_checksum -> raise Invalid_checksum
         | Es.Iban.Invalid_format -> raise Invalid_format
         | Es.Iban.Invalid_length -> raise Invalid_length
         | Es.Iban.Invalid_component -> raise Invalid_component)
     | _ -> ());

  number

let is_valid ?(check_country = true) number =
  try
    ignore (validate ~check_country number);
    true
  with
  | Invalid_component | Invalid_checksum | Invalid_length | Invalid_format ->
    false

let format ?(separator = " ") number =
  let number = compact number in
  let rec split_into_fours str pos acc =
    if pos >= String.length str then List.rev acc
    else if pos + 4 <= String.length str then
      split_into_fours str (pos + 4) (String.sub str pos 4 :: acc)
    else
      split_into_fours str (String.length str)
        (String.sub str pos (String.length str - pos) :: acc)
  in
  String.concat separator (split_into_fours number 0 [])
