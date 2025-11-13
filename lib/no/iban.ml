(** Norwegian IBAN (International Bank Account Number).

    The IBAN is used to identify bank accounts across national borders. The
    Norwegian IBAN is built up of the IBAN prefix (NO) and check digits, followed
    by the 11 digit Konto nr. (bank account number).

    More information:
    - https://en.wikipedia.org/wiki/International_Bank_Account_Number *)

open Tools

exception Invalid_component
exception Invalid_length
exception Invalid_format
exception Invalid_checksum

let compact number =
  Utils.clean number "[ \\-]" |> String.uppercase_ascii |> String.trim

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

let to_kontonr number =
  let number = compact number in
  if String.length number < 2 then raise Invalid_length;
  if String.sub number 0 2 <> "NO" then raise Invalid_component;
  if String.length number < 4 then raise Invalid_length;
  String.sub number 4 (String.length number - 4)

let validate number =
  let number = compact number in

  (* Check minimum length for country code *)
  if String.length number < 2 then raise Invalid_length;

  (* Check country code first *)
  if String.sub number 0 2 <> "NO" then raise Invalid_component;

  (* Check length - Norwegian IBAN should be 15 characters (NO + 2 check + 11 account) *)
  if String.length number <> 15 then raise Invalid_length;

  (* Check format (all alphanumeric) *)
  for i = 0 to String.length number - 1 do
    let c = number.[i] in
    if not ((c >= 'A' && c <= 'Z') || (c >= '0' && c <= '9')) then
      raise Invalid_format
  done;

  (* Validate IBAN checksum *)
  validate_iban_checksum number;

  (* Validate the Norwegian bank account number part *)
  let kontonr_part = to_kontonr number in
  ignore (Kontonr.validate kontonr_part);

  number

let is_valid number =
  try
    ignore (validate number);
    true
  with
  | Invalid_format | Invalid_length | Invalid_checksum | Invalid_component ->
      false
  | Kontonr.Invalid_format | Kontonr.Invalid_length | Kontonr.Invalid_checksum
    ->
      false
