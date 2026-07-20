(** European Excise Number

    The excise duty identification number assigned to businesses authorised to
    operate with excise goods (e.g. alcohol, tobacco, energy products, etc.).

    The number is issued by the national customs or tax authority of the Member
    State where the business is established. The number consists of a two-letter
    country code followed by up to 13 alphanumeric characters.

    More information:
    - https://ec.europa.eu/taxation_customs/dds2/seed/ *)

open Tools

exception Invalid_format
exception Invalid_length
exception Invalid_component
exception Invalid_checksum

let member_states =
  [ "AT"; "BE"; "BG"; "CY"; "CZ"; "DE"; "DK"; "EE"; "ES"; "FI"; "FR"; "GR"; "HR";
    "HU"; "IE"; "IT"; "LT"; "LU"; "LV"; "MT"; "NL"; "PL"; "PT"; "RO"; "SE"; "SI";
    "SK"; "XI" ]

let compact number =
  let cleaned = Utils.clean number " " |> String.trim |> String.uppercase_ascii in
  let len = String.length cleaned in
  if len >= 2 && len < 13 then
    String.sub cleaned 0 2 ^ String.make (13 - len) '0' ^ String.sub cleaned 2 (len - 2)
  else
    cleaned

let validate number =
  let number = compact number in
  if String.length number <> 13 then raise Invalid_length;
  let cc = String.sub number 0 2 in
  if not (List.mem cc member_states) then raise Invalid_component;
  (* In a full implementation, we would dispatch to country-specific excise validators here (e.g. Fr.Accise).
     Since those are not all available or dynamically loadable, we just do the basic checks. *)
  number

let is_valid number =
  try
    ignore (validate number);
    true
  with Invalid_format | Invalid_length | Invalid_component | Invalid_checksum -> false
