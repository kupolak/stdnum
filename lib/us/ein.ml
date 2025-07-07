open Tools

exception Invalid_format

let validate number =
  let cleaned = Utils.clean number "-" |> String.trim in
  if String.length cleaned <> 9 then raise Invalid_format;
  if not (Utils.is_digits cleaned) then raise Invalid_format;
  (* EIN validation - first two digits must be between 01-99 *)
  let prefix = String.sub cleaned 0 2 in
  if prefix = "00" then raise Invalid_format;
  cleaned

let is_valid number =
  try
    ignore (validate number);
    true
  with Invalid_format -> false

let format number =
  if String.length number = 9 && Utils.is_digits number then
    String.sub number 0 2 ^ "-" ^ String.sub number 2 7
  else number
