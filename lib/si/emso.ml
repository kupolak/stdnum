open Tools

exception Invalid_checksum
exception Invalid_length
exception Invalid_format
exception Invalid_component

(* Region codes mapping *)
let regions =
  [
    ("50", "Celje")
  ; ("42", "Kranj")
  ; ("43", "Kranj")
  ; ("30", "Koper")
  ; ("31", "Koper")
  ; ("32", "Koper")
  ; ("33", "Koper")
  ; ("34", "Koper")
  ; ("35", "Koper")
  ; ("36", "Koper")
  ; ("37", "Koper")
  ; ("38", "Koper")
  ; ("39", "Koper")
  ; ("63", "Koper")
  ; ("41", "Kranj")
  ; ("84", "Murska Sobota")
  ; ("94", "Murska Sobota")
  ; ("21", "Ljubljana")
  ; ("22", "Ljubljana")
  ; ("23", "Ljubljana")
  ; ("24", "Ljubljana")
  ; ("25", "Ljubljana")
  ; ("26", "Ljubljana")
  ; ("27", "Ljubljana")
  ; ("28", "Ljubljana")
  ; ("29", "Ljubljana")
  ; ("11", "Maribor")
  ; ("12", "Maribor")
  ; ("13", "Maribor")
  ; ("14", "Maribor")
  ; ("15", "Maribor")
  ; ("16", "Maribor")
  ; ("17", "Maribor")
  ; ("18", "Maribor")
  ; ("19", "Maribor")
  ; ("44", "Murska Sobota")
  ; ("45", "Murska Sobota")
  ; ("46", "Murska Sobota")
  ; ("47", "Murska Sobota")
  ; ("48", "Murska Sobota")
  ; ("49", "Murska Sobota")
  ]

let compact number = Utils.clean number "[ .-]" |> String.trim

let calc_check_digit number =
  let weights = [| 7; 6; 5; 4; 3; 2; 7; 6; 5; 4; 3; 2 |] in
  let total = ref 0 in
  for i = 0 to 11 do
    let digit = int_of_char number.[i] - int_of_char '0' in
    total := !total + (digit * weights.(i))
  done;
  (* Python: -total % 11 % 10 - Python's mod always returns non-negative *)
  let mod11 = (11 - (!total mod 11)) mod 11 in
  let check = mod11 mod 10 in
  string_of_int check

let get_birth_date number =
  let number = compact number in
  let day = int_of_string (String.sub number 0 2) in
  let month = int_of_string (String.sub number 2 2) in
  let year = int_of_string (String.sub number 4 3) in

  (* Adjust year based on value - years < 800 add 2000, >= 800 add 1000 *)
  let full_year = if year < 800 then year + 2000 else year + 1000 in

  (* Validate date *)
  if month < 1 || month > 12 then raise Invalid_component;
  if day < 1 || day > 31 then raise Invalid_component;

  (* Simple month-day validation *)
  if month = 2 && day > 29 then raise Invalid_component;
  if (month = 4 || month = 6 || month = 9 || month = 11) && day > 30 then
    raise Invalid_component;

  (full_year, month, day)

let get_gender number =
  let number = compact number in
  let personal = int_of_string (String.sub number 9 3) in
  if personal < 500 then "M" else "F"

let get_region number =
  let number = compact number in
  let region_code = String.sub number 6 2 in
  try List.assoc region_code regions with Not_found -> ""

let validate number =
  let number = compact number in

  (* Check length *)
  if String.length number <> 13 then raise Invalid_length;

  (* Check all digits *)
  if not (Utils.is_digits number) then raise Invalid_format;

  (* Validate date *)
  (try ignore (get_birth_date number)
   with Invalid_component -> raise Invalid_component);

  (* Validate checksum *)
  let expected_check = calc_check_digit number in
  let actual_check = String.sub number 12 1 in
  if expected_check <> actual_check then raise Invalid_checksum;

  number

let is_valid number =
  try
    ignore (validate number);
    true
  with
  | Invalid_checksum | Invalid_length | Invalid_format | Invalid_component ->
    false

let format number =
  let number = compact number in
  number
