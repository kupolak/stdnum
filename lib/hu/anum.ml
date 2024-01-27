open Tools

exception Invalid_format
exception Invalid_length
exception Invalid_checksum

let compact number =
  let cleaned_number =
    String.uppercase_ascii (String.trim (Utils.clean number "-"))
  in
  if String.sub cleaned_number 0 2 = "HU" then
    String.sub cleaned_number 2 (String.length cleaned_number - 2)
  else cleaned_number

let checksum number =
  let weights = [ 9; 7; 3; 1; 9; 7; 3; 1 ] in
  let sum = ref 0 in
  String.iteri
    (fun i digit ->
      sum := !sum + (List.nth weights i * (int_of_char digit - int_of_char '0')))
    number;
  !sum mod 10

let validate number =
  let compacted_number = compact number in
  if not (Str.string_match (Str.regexp "^[0-9]+$") compacted_number 0) then
    raise Invalid_format;
  if String.length compacted_number <> 8 then raise Invalid_length;
  if checksum compacted_number <> 0 then raise Invalid_checksum;
  compacted_number

let is_valid number =
  try
    ignore (validate number);
    true
  with Invalid_format | Invalid_length | Invalid_checksum -> false
