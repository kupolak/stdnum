open Tools

exception Invalid_length
exception Invalid_format
exception Invalid_component
exception Invalid_checksum

(* Romanian counties mapping *)
let counties =
  [
    ("01", "Alba")
  ; ("02", "Arad")
  ; ("03", "Arges")
  ; ("04", "Bacau")
  ; ("05", "Bihor")
  ; ("06", "Bistrita-Nasaud")
  ; ("07", "Botosani")
  ; ("08", "Brasov")
  ; ("09", "Braila")
  ; ("10", "Buzau")
  ; ("11", "Caras-Severin")
  ; ("12", "Cluj")
  ; ("13", "Constanta")
  ; ("14", "Covasna")
  ; ("15", "Dambovita")
  ; ("16", "Dolj")
  ; ("17", "Galati")
  ; ("18", "Gorj")
  ; ("19", "Harghita")
  ; ("20", "Hunedoara")
  ; ("21", "Ialomita")
  ; ("22", "Iasi")
  ; ("23", "Ilfov")
  ; ("24", "Maramures")
  ; ("25", "Mehedinti")
  ; ("26", "Mures")
  ; ("27", "Neamt")
  ; ("28", "Olt")
  ; ("29", "Prahova")
  ; ("30", "Satu Mare")
  ; ("31", "Salaj")
  ; ("32", "Sibiu")
  ; ("33", "Suceava")
  ; ("34", "Teleorman")
  ; ("35", "Timis")
  ; ("36", "Tulcea")
  ; ("37", "Vaslui")
  ; ("38", "Valcea")
  ; ("39", "Vrancea")
  ; ("40", "Bucuresti")
  ; ("41", "Bucuresti - Sector 1")
  ; ("42", "Bucuresti - Sector 2")
  ; ("43", "Bucuresti - Sector 3")
  ; ("44", "Bucuresti - Sector 4")
  ; ("45", "Bucuresti - Sector 5")
  ; ("46", "Bucuresti - Sector 6")
  ; ("47", "Bucuresti - Sector 7 (desfiintat)")
  ; ("48", "Bucuresti - Sector 8 (desfiintat)")
  ; ("51", "Calarasi")
  ; ("52", "Giurgiu")
  ; ("70", "Any")
  ; ("80", "Unknown")
  ; ("81", "Unknown")
  ; ("82", "Unknown")
  ; ("83", "Unknown")
  ]

module CountyMap = Map.Make (String)

let county_map =
  List.fold_left
    (fun map (code, name) -> CountyMap.add code name map)
    CountyMap.empty counties

let compact number = Utils.clean number "[ -]+" |> String.trim

let calc_check_digit number =
  let weights = [| 2; 7; 9; 1; 4; 6; 3; 5; 8; 2; 7; 9 |] in
  let sum = ref 0 in
  for i = 0 to 11 do
    let digit = int_of_char number.[i] - int_of_char '0' in
    sum := !sum + (weights.(i) * digit)
  done;
  let check = !sum mod 11 in
  if check = 10 then "1" else string_of_int check

let get_birth_date number =
  let number = compact number in
  let gender_century = number.[0] in
  let year_suffix = int_of_string (String.sub number 1 2) in
  let month = int_of_string (String.sub number 3 2) in
  let day = int_of_string (String.sub number 5 2) in

  (* Determine century based on first digit *)
  let century =
    match gender_century with
    | '1' | '2' -> 1900
    | '3' | '4' -> 1800
    | '5' | '6' -> 2000
    | _ -> 1900
    (* Default to 1900 for others *)
  in
  let year = century + year_suffix in

  (* Validate date components *)
  if month < 1 || month > 12 then raise Invalid_component;
  if day < 1 || day > 31 then raise Invalid_component;

  (* Validate date is valid (e.g., no Feb 30) *)
  let is_leap_year y = y mod 4 = 0 && (y mod 100 <> 0 || y mod 400 = 0) in
  let days_in_month =
    match month with
    | 1 | 3 | 5 | 7 | 8 | 10 | 12 -> 31
    | 4 | 6 | 9 | 11 -> 30
    | 2 -> if is_leap_year year then 29 else 28
    | _ -> raise Invalid_component
  in
  if day > days_in_month then raise Invalid_component;

  (year, month, day)

let get_county number =
  let number = compact number in
  let county_code = String.sub number 7 2 in
  match CountyMap.find_opt county_code county_map with
  | Some name -> name
  | None -> raise Invalid_component

let validate number =
  let number = compact number in

  (* Check if it contains only digits *)
  if not (Utils.is_digits number) then raise Invalid_format;

  (* Check length *)
  if String.length number <> 13 then raise Invalid_length;

  (* Check first digit (gender/century indicator) *)
  if not (List.mem number.[0] [ '1'; '2'; '3'; '4'; '5'; '6'; '7'; '8'; '9' ])
  then raise Invalid_component;

  (* Validate birth date *)
  let _year, _month, _day = get_birth_date number in

  (* Validate county *)
  let _county = get_county number in

  (* Validate checksum *)
  let body = String.sub number 0 12 in
  let check_digit = String.sub number 12 1 in
  if calc_check_digit body <> check_digit then raise Invalid_checksum;

  number

let is_valid number =
  try
    ignore (validate number);
    true
  with
  | Invalid_format | Invalid_length | Invalid_component | Invalid_checksum ->
    false
