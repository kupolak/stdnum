open Tools

exception Invalid_component
exception Invalid_checksum
exception Invalid_length
exception Invalid_format

let compact number =
  Utils.clean number "[ -]" |> String.uppercase_ascii |> String.trim

let format number =
  (* Format as standard IBAN: ES77 1234 1234 1612 3456 7890 *)
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

let to_ccc number =
  (* Return the CCC part of the number *)
  let number = compact number in
  if String.length number < 2 || String.sub number 0 2 <> "ES" then
    raise Invalid_component;
  String.sub number 4 (String.length number - 4)

let validate_iban_checksum number =
  (* Validate IBAN check digits using mod 97 algorithm *)
  let number = compact number in

  (* Move first 4 characters to the end *)
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

let validate number =
  (* Check if the number is a valid Spanish IBAN *)
  let number = compact number in

  (* Check length (Spanish IBAN is 24 characters) *)
  if String.length number <> 24 then raise Invalid_length;

  (* Check country code *)
  if String.sub number 0 2 <> "ES" then raise Invalid_component;

  (* Validate IBAN checksum *)
  validate_iban_checksum number;

  (* Validate CCC part *)
  let ccc_part = to_ccc number in
  (try ignore (Ccc.validate ccc_part) with
  | Ccc.Invalid_checksum -> raise Invalid_checksum
  | Ccc.Invalid_format -> raise Invalid_format
  | Ccc.Invalid_length -> raise Invalid_length);

  number

let is_valid number =
  try
    ignore (validate number);
    true
  with
  | Invalid_component | Invalid_checksum | Invalid_length | Invalid_format ->
    false
