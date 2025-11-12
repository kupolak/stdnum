open Tools

exception Invalid_length
exception Invalid_format
exception Invalid_checksum
exception Invalid_component

let compact number =
  Utils.clean number "[ -]" |> String.trim |> String.uppercase_ascii

let format number =
  let number = compact number in
  let parts =
    [
      String.sub number 0 2
    ; String.sub number 2 4
    ; String.sub number 6 4
    ; String.sub number 10 4
    ; String.sub number 14 4
    ; String.sub number 18 2
    ]
  in
  let formatted = String.concat " " parts in
  if String.length number > 20 then
    formatted ^ " " ^ String.sub number 20 (String.length number - 20)
  else formatted

let calc_check_digits number =
  (* Calculate the check digits for the number *)
  let alphabet = "TRWAGMYFPDXBNJZSQVHLCKE" in
  let base_number = String.sub number 2 16 in
  let value = int_of_string base_number mod 529 in
  let check0 = value / 23 in
  let check1 = value mod 23 in
  String.make 1 alphabet.[check0] ^ String.make 1 alphabet.[check1]

let validate number =
  let number = compact number in
  let len = String.length number in

  (* Check length *)
  if len <> 20 && len <> 22 then raise Invalid_length;

  (* Check country code *)
  if String.sub number 0 2 <> "ES" then raise Invalid_component;

  (* Check that middle part is all digits *)
  let middle = String.sub number 2 16 in
  if not (Utils.is_digits middle) then raise Invalid_format;

  (* If 22 characters, validate border point *)
  if len = 22 then (
    let pnumber = number.[20] in
    let ptype = number.[21] in
    if not (pnumber >= '0' && pnumber <= '9') then raise Invalid_format;
    if not (String.contains "FPRCXYZ" ptype) then raise Invalid_format);

  (* Validate check digits *)
  let calculated = calc_check_digits number in
  let provided = String.sub number 18 2 in
  if calculated <> provided then raise Invalid_checksum;

  number

let is_valid number =
  try
    ignore (validate number);
    true
  with
  | Invalid_format | Invalid_length | Invalid_checksum | Invalid_component ->
    false
