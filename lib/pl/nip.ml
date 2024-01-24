open Tools

exception Invalid_format
exception Invalid_length
exception Invalid_checksum

let compact number =
  let number =
    Utils.clean number "-" |> String.uppercase_ascii |> String.trim
  in
  if String.sub number 0 2 = "PL" then
    String.sub number 2 (String.length number - 2)
  else number

let checksum number =
  let weights = [| 6; 5; 7; 2; 3; 4; 5; 6; 7; -1 |] in
  if String.length number <> Array.length weights then raise Invalid_length;

  let digits = Array.map Char.escaped (String.to_seq number |> Array.of_seq) in
  let weighted_sum =
    Array.map2 (fun w n -> w * int_of_string n) weights digits
  in
  Array.fold_left ( + ) 0 weighted_sum mod 11

let validate number =
  let compact_number = compact number in

  if not (Utils.is_digits compact_number) then raise Invalid_format;

  if String.length compact_number <> 10 then raise Invalid_length;

  if checksum compact_number <> 0 then raise Invalid_checksum;

  compact_number

let is_valid number =
  try
    ignore (validate number);
    true
  with Invalid_format | Invalid_length | Invalid_checksum -> false

let format number =
  let compact_number = compact number in
  let chunks =
    [ (0, 3); (3, 3); (6, 2); (8, 2) ]
    |> List.map (fun (start, len) -> String.sub compact_number start len)
  in
  String.concat "-" chunks
