(** VAT (European Union VAT number).

    The European Union VAT number consists of a 2 letter country code (ISO
    3166-1, except Greece which uses EL) followed by a number that is allocated
    per country.

    The exact format of the numbers varies per country. In this OCaml port,
    without dynamic module loading, we perform a basic prefix and format check,
    and delegate to a few known validators where possible.

    More information:
    - https://en.wikipedia.org/wiki/VAT_identification_number *)

open Tools

exception Invalid_format
exception Invalid_length
exception Invalid_component

let member_states =
  [
    "AT"
  ; "BE"
  ; "BG"
  ; "CY"
  ; "CZ"
  ; "DE"
  ; "DK"
  ; "EE"
  ; "ES"
  ; "FI"
  ; "FR"
  ; "GR"
  ; "HR"
  ; "HU"
  ; "IE"
  ; "IT"
  ; "LT"
  ; "LU"
  ; "LV"
  ; "MT"
  ; "NL"
  ; "PL"
  ; "PT"
  ; "RO"
  ; "SE"
  ; "SI"
  ; "SK"
  ; "XI"
  ; "EL"
  ]

let compact number =
  Utils.clean number "[ \t.-]" |> String.trim |> String.uppercase_ascii

let validate number =
  let number = compact number in
  if String.length number < 4 then raise Invalid_length;
  let cc = String.sub number 0 2 in
  let cc = if cc = "EL" then "GR" else cc in
  if not (List.mem cc member_states) then raise Invalid_component;

  if not (Utils.is_alnum number) then raise Invalid_format;

  (* Basic validation passed. In a full system, country-specific VAT modules
     would be invoked here based on the country code. *)
  number

let validate_result number =
  try Ok (validate number) with
  | Invalid_format -> Error Error.Invalid_format
  | Invalid_length -> Error Error.Invalid_length
  | Invalid_component -> Error Tools.Error.Invalid_component

let is_valid number =
  try
    ignore (validate number);
    true
  with Invalid_format | Invalid_length | Invalid_component -> false

let guess_country number =
  let number = compact number in
  if String.length number >= 2 then
    let cc = String.sub number 0 2 in
    let cc = if cc = "EL" then "GR" else cc in
    if List.mem cc member_states then [ String.lowercase_ascii cc ] else []
  else []
