open Tools

exception Invalid_format
exception Invalid_length
exception Invalid_checksum
exception Invalid_component

let compact number =
  (* Remove dashes and spaces *)
  Utils.clean number "[ -]" |> String.trim

let validate number =
  let number = compact number in

  (* Check length: must be 9 (BN) or 15 (BN15) digits *)
  if String.length number <> 9 && String.length number <> 15 then
    raise Invalid_length;

  (* Check if first 9 characters are digits *)
  let first_9 = String.sub number 0 9 in
  if not (Utils.is_digits first_9) then raise Invalid_format;

  (* Validate first 9 digits using Luhn algorithm *)
  (try ignore (Luhn.validate first_9)
   with Luhn.Invalid_checksum -> raise Invalid_checksum);

  (* If 15 digits, validate program identifier and reference number *)
  if String.length number = 15 then (
    (* Check program identifier (positions 9-10): must be RC, RM, RP, or RT *)
    let program_id = String.sub number 9 2 in
    if
      program_id <> "RC" && program_id <> "RM" && program_id <> "RP"
      && program_id <> "RT"
    then raise Invalid_component;

    (* Check reference number (positions 11-14): must be 4 digits *)
    let ref_num = String.sub number 11 4 in
    if not (Utils.is_digits ref_num) then raise Invalid_format);

  number

let is_valid number =
  try
    ignore (validate number);
    true
  with
  | Invalid_format | Invalid_length | Invalid_checksum | Invalid_component ->
    false
