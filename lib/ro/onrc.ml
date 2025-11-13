exception Invalid_length
exception Invalid_format
exception Invalid_component

module IntSet = Set.Make (Int)

(* List of valid counties *)
let valid_counties =
  let counties_1_40 = List.init 40 (fun i -> i + 1) in
  let counties_extra = [ 51; 52 ] in
  let all = counties_1_40 @ counties_extra in
  List.fold_left (fun set x -> IntSet.add x set) IntSet.empty all

let compact number =
  (* Convert to uppercase and trim *)
  let number = String.uppercase_ascii number |> String.trim in
  (* Replace all separators (spaces, backslashes, hyphens) with slashes *)
  let number = Str.global_replace (Str.regexp "[ \\\\-]+") "/" number in
  (* Replace multiple slashes with single slash *)
  let number = Str.global_replace (Str.regexp "/+") "/" number in
  (* Remove optional slash between first letter and county digits *)
  let number =
    if String.length number > 1 && number.[1] = '/' then
      String.sub number 0 1 ^ String.sub number 2 (String.length number - 2)
    else number
  in
  (* Normalize county number to two digits *)
  let number =
    if String.length number > 2 && number.[2] = '/' then
      String.sub number 0 1 ^ "0"
      ^ String.sub number 1 (String.length number - 1)
    else number
  in
  (* Convert trailing full date (DD.MM.YYYY) to year only *)
  let fulldate_pattern =
    Str.regexp
      "^\\([A-Z][0-9]+/[0-9]+/\\)[0-9][0-9]\\.[0-9][0-9]\\.\\([0-9][0-9][0-9][0-9]\\)$"
  in
  if Str.string_match fulldate_pattern number 0 then
    Str.matched_group 1 number ^ Str.matched_group 2 number
  else number

let validate number =
  let number = compact number in
  (* Check format: [A-Z][0-9]+/[0-9]+/[0-9]+ *)
  let pattern = Str.regexp "^[A-Z][0-9]+/[0-9]+/[0-9]+$" in
  if not (Str.string_match pattern number 0) then raise Invalid_format;

  (* Check first character is J, F, or C *)
  if not (List.mem number.[0] [ 'J'; 'F'; 'C' ]) then raise Invalid_component;

  (* Split the number *)
  let parts =
    String.split_on_char '/' (String.sub number 1 (String.length number - 1))
  in
  match parts with
  | [ county_str; serial; year ] ->
      (* Check serial number length (max 5 digits) *)
      if String.length serial > 5 then raise Invalid_length;

      (* Check county *)
      let county_len = String.length county_str in
      if county_len < 1 || county_len > 2 then raise Invalid_component;
      let county = int_of_string county_str in
      if not (IntSet.mem county valid_counties) then raise Invalid_component;

      (* Check year *)
      if String.length year <> 4 then raise Invalid_length;
      let year_int = int_of_string year in
      let now = Unix.time () in
      let tm = Unix.localtime now in
      let current_year = tm.Unix.tm_year + 1900 in
      if year_int < 1990 || year_int > current_year then raise Invalid_component;

      number
  | _ -> raise Invalid_format

let is_valid number =
  try
    ignore (validate number);
    true
  with Invalid_format | Invalid_length | Invalid_component -> false
