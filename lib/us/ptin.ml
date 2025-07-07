open Tools

exception Invalid_format

let validate number =
  let cleaned = Utils.clean number "-" |> String.trim in
  if String.length cleaned <> 9 then raise Invalid_format;
  (* PTIN validation - starts with P followed by 8 digits *)
  let first_char = String.get cleaned 0 in
  if first_char <> 'P' then raise Invalid_format;
  let digits = String.sub cleaned 1 8 in
  if not (Utils.is_digits digits) then raise Invalid_format;
  cleaned

let is_valid number =
  try
    ignore (validate number);
    true
  with Invalid_format -> false

let format number =
  if String.length number = 9 && String.get number 0 = 'P' then
    "P" ^ String.sub number 1 8
  else number
