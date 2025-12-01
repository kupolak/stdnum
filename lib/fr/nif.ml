open Tools

exception Invalid_checksum
exception Invalid_length
exception Invalid_format
exception Invalid_component

let compact number = Utils.clean number "[ ]" |> String.trim

let calc_check_digits number =
  let first_10 = String.sub number 0 10 in
  let value = int_of_string first_10 in
  let check = value mod 511 in
  Printf.sprintf "%03d" check

let validate number =
  let number = compact number in

  (* Check if all digits *)
  if not (Utils.is_digits number) then raise Invalid_format;

  (* Check first digit is 0, 1, 2, or 3 *)
  if not (List.mem (String.get number 0) [ '0'; '1'; '2'; '3' ]) then
    raise Invalid_component;

  (* Check length *)
  if String.length number <> 13 then raise Invalid_length;

  (* Validate check digits *)
  let expected_check = calc_check_digits number in
  let actual_check = String.sub number 10 3 in
  if expected_check <> actual_check then raise Invalid_checksum;

  number

let is_valid number =
  try
    let _ = validate number in
    true
  with _ -> false

let format number =
  let number = compact number in
  let part1 = String.sub number 0 2 in
  let part2 = String.sub number 2 2 in
  let part3 = String.sub number 4 3 in
  let part4 = String.sub number 7 3 in
  let part5 = String.sub number 10 3 in
  Printf.sprintf "%s %s %s %s %s" part1 part2 part3 part4 part5
