(** CI (Cédula de identidad, Ecuadorian personal identity code).

    The CI is a 10 digit number used to identify Ecuadorian citizens. *)

open Tools

exception Invalid_format
exception Invalid_length
exception Invalid_component
exception Invalid_checksum

let compact number =
  Utils.clean number "[ -]" |> String.trim |> String.uppercase_ascii

let validate number =
  let number = compact number in
  if String.length number <> 10 then raise Invalid_length;
  if not (Utils.is_digits number) then raise Invalid_format;

  let prov_code = String.sub number 0 2 in
  if
    (prov_code < "01" || prov_code > "24")
    && prov_code <> "30" && prov_code <> "50"
  then raise Invalid_component;

  if number.[2] > '6' then raise Invalid_component;

  begin try ignore (Luhn.validate number) with
  | Luhn.Invalid_checksum -> raise Invalid_checksum
  | Luhn.Invalid_format -> raise Invalid_format
  end;

  number

let is_valid number =
  try
    ignore (validate number);
    true
  with
  | Invalid_format | Invalid_length | Invalid_component | Invalid_checksum ->
    false
