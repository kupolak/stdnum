open Tools

exception Invalid_length
exception Invalid_format
exception Invalid_component
exception Invalid_checksum

let other_uen_entity_types =
  [
    "CC"
  ; "CD"
  ; "CH"
  ; "CL"
  ; "CM"
  ; "CP"
  ; "CS"
  ; "CX"
  ; "DP"
  ; "FB"
  ; "FC"
  ; "FM"
  ; "FN"
  ; "GA"
  ; "GB"
  ; "GS"
  ; "HS"
  ; "LL"
  ; "LP"
  ; "MB"
  ; "MC"
  ; "MD"
  ; "MH"
  ; "MM"
  ; "MQ"
  ; "NB"
  ; "NR"
  ; "PA"
  ; "PB"
  ; "PF"
  ; "RF"
  ; "RP"
  ; "SM"
  ; "SS"
  ; "TC"
  ; "TU"
  ; "VH"
  ; "XL"
  ]

let compact number =
  Utils.clean number "" |> String.uppercase_ascii |> String.trim

let calc_business_check_digit number =
  let number = compact number in
  let weights = [| 10; 4; 9; 3; 8; 2; 7; 1 |] in
  let check_chars = "XMKECAWLJDB" in
  let total = ref 0 in
  for i = 0 to 7 do
    let digit = int_of_char number.[i] - int_of_char '0' in
    total := !total + (digit * weights.(i))
  done;
  String.make 1 check_chars.[!total mod 11]

let validate_business number =
  (* First 8 digits must be digits *)
  if not (Utils.is_digits (String.sub number 0 8)) then raise Invalid_format;
  (* Last character must be alpha *)
  let last_char = number.[8] in
  if not (last_char >= 'A' && last_char <= 'Z') then raise Invalid_format;
  (* Check digit validation *)
  if String.make 1 last_char <> calc_business_check_digit number then
    raise Invalid_checksum;
  number

let calc_local_company_check_digit number =
  let number = compact number in
  let weights = [| 10; 8; 6; 4; 9; 7; 5; 3; 1 |] in
  let check_chars = "ZKCMDNERGWH" in
  let total = ref 0 in
  for i = 0 to 8 do
    let digit = int_of_char number.[i] - int_of_char '0' in
    total := !total + (digit * weights.(i))
  done;
  String.make 1 check_chars.[!total mod 11]

let validate_local_company number =
  (* First 9 digits must be digits *)
  if not (Utils.is_digits (String.sub number 0 9)) then raise Invalid_format;
  (* Year validation - first 4 digits should not be greater than current year *)
  let year = String.sub number 0 4 in
  let current_year =
    string_of_int (1900 + (Unix.localtime (Unix.time ())).Unix.tm_year)
  in
  if year > current_year then raise Invalid_component;
  (* Check digit validation *)
  if String.make 1 number.[9] <> calc_local_company_check_digit number then
    raise Invalid_checksum;
  number

let calc_other_check_digit number =
  let number = compact number in
  let alphabet = "ABCDEFGHJKLMNPQRSTUVWX0123456789" in
  let weights = [| 4; 3; 5; 3; 10; 2; 2; 5; 7 |] in
  let total = ref 0 in
  for i = 0 to 8 do
    let char_val = String.index alphabet number.[i] in
    total := !total + (char_val * weights.(i))
  done;
  let check_index = (!total - 5) mod 11 in
  String.make 1 alphabet.[check_index]

let validate_other number =
  (* First character must be R, S, or T *)
  let first_char = number.[0] in
  if first_char <> 'R' && first_char <> 'S' && first_char <> 'T' then
    raise Invalid_component;
  (* Next 2 characters must be digits *)
  if not (Utils.is_digits (String.sub number 1 2)) then raise Invalid_format;
  (* For T entities, year must not be in the future *)
  (if first_char = 'T' then
     let year_suffix = String.sub number 1 2 in
     let current_year =
       string_of_int (1900 + (Unix.localtime (Unix.time ())).Unix.tm_year)
     in
     let current_year_suffix = String.sub current_year 2 2 in
     if year_suffix > current_year_suffix then raise Invalid_component);
  (* Entity type (positions 3-4) must be valid *)
  let entity_type = String.sub number 3 2 in
  if not (List.mem entity_type other_uen_entity_types) then
    raise Invalid_component;
  (* Next 4 characters must be digits *)
  if not (Utils.is_digits (String.sub number 5 4)) then raise Invalid_format;
  (* Check digit validation *)
  if String.make 1 number.[9] <> calc_other_check_digit number then
    raise Invalid_checksum;
  number

let validate number =
  let number = compact number in
  let len = String.length number in
  if len <> 9 && len <> 10 then raise Invalid_length;
  if len = 9 then validate_business number
  else if (* Length is 10 *)
          number.[0] >= '0' && number.[0] <= '9' then
    validate_local_company number
  else validate_other number

let is_valid number =
  try
    ignore (validate number);
    true
  with
  | Invalid_format | Invalid_length | Invalid_component | Invalid_checksum ->
    false

let format number = compact number
