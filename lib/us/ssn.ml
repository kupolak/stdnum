open Tools

exception Invalid_format

let validate number =
  let cleaned = Utils.clean number "-" |> String.trim in
  if String.length cleaned <> 9 then raise Invalid_format;
  if not (Utils.is_digits cleaned) then raise Invalid_format;
  (* Basic SSN validation - no 000-xx-xxxx, xxx-00-xxxx, or xxx-xx-0000 *)
  let area = String.sub cleaned 0 3 in
  let group = String.sub cleaned 3 2 in
  let serial = String.sub cleaned 5 4 in
  if area = "000" || group = "00" || serial = "0000" then raise Invalid_format;
  cleaned

let is_valid number =
  try
    ignore (validate number);
    true
  with Invalid_format -> false

let format number =
  if String.length number = 9 && Utils.is_digits number then
    String.sub number 0 3 ^ "-" ^ String.sub number 3 2 ^ "-"
    ^ String.sub number 5 4
  else number
