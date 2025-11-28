open Tools

exception Invalid_checksum
exception Invalid_length
exception Invalid_format

let compact number =
  Utils.clean number "[ .,:/-]" |> String.uppercase_ascii |> String.trim

let validate number =
  let number = compact number in

  (* Check length: minimum 5 (RF + 2 check digits + at least 1 character),
     maximum 25 (RF + 2 check digits + 21 characters) *)
  let len = String.length number in
  if len < 5 || len > 25 then raise Invalid_length;

  (* Check that it starts with RF *)
  if String.length number < 2 || String.sub number 0 2 <> "RF" then
    raise Invalid_format;

  (* Validate using ISO 7064 Mod 97, 10 checksum
     Move RF and check digits to end: number[4:] + number[:4] *)
  let rearranged =
    String.sub number 4 (String.length number - 4) ^ String.sub number 0 4
  in
  (* Check the checksum directly rather than using validate
     because mod_97_10.validate catches all exceptions as Invalid_format *)
  let checksum_value = Iso7064.Mod_97_10.checksum rearranged in
  if checksum_value <> 1 then raise Invalid_checksum;

  number

let is_valid number =
  try
    ignore (validate number);
    true
  with Invalid_checksum | Invalid_length | Invalid_format -> false

let format number =
  let number = compact number in
  (* Split into blocks of 4 characters *)
  let rec split_into_fours str pos acc =
    if pos >= String.length str then List.rev acc
    else if pos + 4 <= String.length str then
      split_into_fours str (pos + 4) (String.sub str pos 4 :: acc)
    else
      split_into_fours str (String.length str)
        (String.sub str pos (String.length str - pos) :: acc)
  in
  String.concat " " (split_into_fours number 0 [])
