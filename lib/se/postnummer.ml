open Tools

exception Invalid_length
exception Invalid_format

let compact number =
  let cleaned =
    Utils.clean number "[ -]" |> String.uppercase_ascii |> String.trim
  in
  if String.length cleaned >= 2 && String.sub cleaned 0 2 = "SE" then
    String.sub cleaned 2 (String.length cleaned - 2)
  else cleaned

let validate number =
  let number = compact number in
  if String.length number <> 5 then raise Invalid_length;
  if not (Utils.is_digits number) then raise Invalid_format;
  if number.[0] = '0' then raise Invalid_format;
  number

let is_valid number =
  try
    ignore (validate number);
    true
  with Invalid_format | Invalid_length -> false

let format number =
  let number = compact number in
  String.sub number 0 3 ^ " " ^ String.sub number 3 2
