open Tools

exception Invalid_format
exception Invalid_checksum

let compact number =
  let cleaned =
    Utils.clean number "[ -.]" |> String.uppercase_ascii |> String.trim
  in
  if String.length cleaned >= 2 && String.sub cleaned 0 2 = "SE" then
    String.sub cleaned 2 (String.length cleaned - 2)
  else cleaned

let validate number =
  let number = compact number in
  if not (Utils.is_digits number) then raise Invalid_format;
  if String.length number <> 12 then raise Orgnr.Invalid_length;
  if String.sub number 10 2 <> "01" then raise Invalid_format;
  (* Validate the first 10 digits using orgnr validation *)
  let orgnr_part = String.sub number 0 10 in
  ignore (Orgnr.validate orgnr_part);
  number

let is_valid number =
  try
    ignore (validate number);
    true
  with
  | Invalid_format | Orgnr.Invalid_length | Orgnr.Invalid_checksum
  | Orgnr.Invalid_format
  ->
    false
