(** MAC address (Media Access Control address).

    A media access control address (MAC address, sometimes Ethernet address) of
    a device is meant as a unique identifier within a network at the data link
    layer.

    More information:
    - https://en.wikipedia.org/wiki/MAC_address
    - https://en.wikipedia.org/wiki/Organizationally_unique_identifier
    - https://standards.ieee.org/faqs/regauth.html#2 *)

open Tools

exception Invalid_format
exception Invalid_length
exception Invalid_component

let compact number =
  let number =
    Utils.clean number " " |> String.trim |> String.lowercase_ascii
  in
  let number = String.concat ":" (String.split_on_char '-' number) in
  let parts = String.split_on_char ':' number in
  let pad_part n = if String.length n = 1 then "0" ^ n else n in
  String.concat ":" (List.map pad_part parts)

let is_valid_hex c = match c with '0' .. '9' | 'a' .. 'f' -> true | _ -> false

let is_mac_re number =
  let parts = String.split_on_char ':' number in
  if List.length parts <> 6 then false
  else
    List.for_all
      (fun p -> String.length p = 2 && is_valid_hex p.[0] && is_valid_hex p.[1])
      parts

let is_unicast number =
  let number = compact number in
  if String.length number >= 2 then
    let first_byte = int_of_string ("0x" ^ String.sub number 0 2) in
    first_byte land 1 = 0
  else false

let is_multicast number = not (is_unicast number)

let is_broadcast number =
  let number = compact number in
  number = "ff:ff:ff:ff:ff:ff"

let is_universally_administered number =
  let number = compact number in
  if String.length number >= 2 then
    let first_byte = int_of_string ("0x" ^ String.sub number 0 2) in
    first_byte land 2 = 0
  else false

let is_locally_administered number = not (is_universally_administered number)

let validate ?(validate_manufacturer = false) number =
  let number = compact number in
  if String.length number <> 17 then raise Invalid_length;
  if not (is_mac_re number) then raise Invalid_format;
  (* OUI manufacturer validation skipped as full IEEE OUI registry is not ported *)
  let _ = validate_manufacturer in
  number

let validate_result number =
  try Ok (validate number) with
  | Invalid_format -> Error Error.Invalid_format
  | Invalid_length -> Error Error.Invalid_length
  | Invalid_component -> Error Tools.Error.Invalid_component

let is_valid ?validate_manufacturer number =
  try
    ignore (validate ?validate_manufacturer number);
    true
  with Invalid_format | Invalid_length | Invalid_component -> false

let to_eui48 number =
  let number = compact number |> String.uppercase_ascii in
  String.concat "-" (String.split_on_char ':' number)
