open Tools

exception Invalid_length
exception Invalid_format
exception Invalid_checksum
exception Invalid_component

let compact number =
  Utils.clean number "[ -]" |> String.uppercase_ascii |> String.trim

let format number =
  let number = compact number in
  let parts = ref [] in
  let rec split_into_fours str pos =
    if pos >= String.length str then ()
    else if pos + 4 <= String.length str then (
      parts := String.sub str pos 4 :: !parts;
      split_into_fours str (pos + 4))
    else parts := String.sub str pos (String.length str - pos) :: !parts
  in
  split_into_fours number 0;
  String.concat " " (List.rev !parts)

let calc_check_digits number =
  (* Calculate the check digits over the provided part of the number *)
  let check = int_of_string number mod 97 in
  let check = if check = 0 then 97 else check in
  Printf.sprintf "%02d" check

let validate_iban_checksum number =
  (* Validate IBAN check digits using mod 97 algorithm *)
  let reordered =
    String.sub number 4 (String.length number - 4) ^ String.sub number 0 4
  in

  (* Convert letters to numbers (A=10, B=11, ..., Z=35) *)
  let numeric = Buffer.create (String.length reordered * 2) in
  String.iter
    (fun c ->
      if c >= 'A' && c <= 'Z' then
        Buffer.add_string numeric
          (string_of_int (int_of_char c - int_of_char 'A' + 10))
      else Buffer.add_char numeric c)
    reordered;

  (* Calculate mod 97 for large number *)
  let rec mod97_string s =
    if String.length s <= 9 then int_of_string s mod 97
    else
      let chunk = String.sub s 0 9 in
      let rest = String.sub s 9 (String.length s - 9) in
      let remainder = int_of_string chunk mod 97 in
      mod97_string (string_of_int remainder ^ rest)
  in

  let remainder = mod97_string (Buffer.contents numeric) in
  if remainder <> 1 then raise Invalid_checksum

(* Bank code ranges with BIC codes *)
let bank_ranges =
  [|
     (0, 49, Some "GEBABEBB")
   ; (50, 99, Some "GKCCBEBB")
   ; (100, 100, Some "NBBEBEBB203")
   ; (101, 101, Some "NBBEBEBBHCC")
   ; (102, 102, None)
   ; (103, 108, Some "NICABEBB")
   ; (109, 110, Some "CTBKBEBX")
   ; (111, 111, Some "ABERBE22")
   ; (113, 114, Some "CTBKBEBX")
   ; (119, 124, Some "CTBKBEBX")
   ; (125, 126, Some "CPHBBE75")
   ; (127, 127, Some "CTBKBEBX")
   ; (129, 129, Some "CTBKBEBX")
   ; (130, 130, Some "DIGEBEB2")
   ; (131, 131, Some "CTBKBEBX")
   ; (132, 132, Some "BNAGBEBB")
   ; (133, 134, Some "CTBKBEBX")
   ; (137, 137, Some "GEBABEBB")
   ; (140, 149, Some "GEBABEBB")
   ; (150, 150, Some "BCMCBEBB")
   ; (171, 171, Some "CPHBBE75")
   ; (175, 175, None)
   ; (176, 176, Some "BSCHBEBBRET")
   ; (185, 185, Some "BBRUBEBB")
   ; (189, 189, Some "SMBCBEBB")
   ; (190, 199, Some "CREGBEBB")
   ; (200, 214, Some "GEBABEBB")
   ; (220, 299, Some "GEBABEBB")
   ; (300, 399, Some "BBRUBEBB")
   ; (400, 499, Some "KREDBEBB")
   ; (500, 599, Some "AXABBE22")
   ; (600, 699, Some "BPOTBEB1")
   ; (700, 799, Some "CREGBEBB")
   ; (800, 899, Some "GKCCBEBB")
   ; (900, 949, Some "AXABBE22")
   ; (950, 974, Some "TRIOBEBB")
   ; (975, 979, Some "GKCCBEBB")
   ; (980, 999, Some "GKCCBEBB")
  |]

let is_valid_bank_code code =
  Array.exists
    (fun (start, end_, _) -> code >= start && code <= end_)
    bank_ranges

let find_bic code =
  let rec search i =
    if i >= Array.length bank_ranges then None
    else
      let start, end_, bic = bank_ranges.(i) in
      if code >= start && code <= end_ then bic else search (i + 1)
  in
  search 0

let to_bic number =
  let number = compact number in
  if String.length number < 7 then None
  else
    let bank_code = int_of_string (String.sub number 4 3) in
    find_bic bank_code

let validate number =
  let number = compact number in

  (* Check minimum length for country code *)
  if String.length number < 2 then raise Invalid_length;

  (* Check country code first *)
  if String.sub number 0 2 <> "BE" then raise Invalid_component;

  (* Check length *)
  if String.length number <> 16 then raise Invalid_length;

  (* Check format (all alphanumeric) *)
  for i = 0 to String.length number - 1 do
    let c = number.[i] in
    if not ((c >= 'A' && c <= 'Z') || (c >= '0' && c <= '9')) then
      raise Invalid_format
  done;

  (* Validate IBAN checksum *)
  validate_iban_checksum number;

  (* Validate Belgian national check digits *)
  let national_part = String.sub number 4 10 in
  let national_check = String.sub number 14 2 in
  let calculated_check = calc_check_digits national_part in
  if calculated_check <> national_check then raise Invalid_checksum;

  (* Check if bank code is known *)
  let bank_code = int_of_string (String.sub number 4 3) in
  if not (is_valid_bank_code bank_code) then raise Invalid_component;

  number

let is_valid number =
  try
    ignore (validate number);
    true
  with
  | Invalid_format | Invalid_length | Invalid_checksum | Invalid_component ->
    false
