(** ISRC (International Standard Recording Code).

    The ISRC is an international standard code (ISO 3901) for uniquely
    identifying sound recordings and music video recordings.

    More information:
    - https://en.wikipedia.org/wiki/International_Standard_Recording_Code *)

open Tools

exception Invalid_format
exception Invalid_length
exception Invalid_component

let country_codes =
  Isin_core.iso_3166_1_country_codes
  @ [
      "BC"
    ; (* Pro-música Brazil - Brasil *)
      "BK"
    ; (* Pro-música Brazil - Brasil *)
      "BP"
    ; (* Pro-música Brazil - Brasil *)
      "BX"
    ; (* Pro-música Brazil - Brasil *)
      "CB"
    ; (* Connect - Canada *)
      "CP"
    ; (* reserved for further overflow *)
      "DG"
    ; (* reserved for further overflow *)
      "FX"
    ; (* SCPP - France *)
      "GX"
    ; (* PPL UK - United Kingdom *)
      "KS"
    ; (* KMCA - South Korea *)
      "QM"
    ; (* US new registrants due to US codes became exhausted *)
      "QN"
    ; (* International ISRC Agency codes - Worldwide *)
      "QT"
    ; (* RIAA - US *)
      "QZ"
    ; (* RIAA - US *)
      "UK"
    ; (* PPL UK - United Kingdom *)
      "XK"
    ; (* International ISRC Agency codes - Kosovo *)
      "YU"
    ; (* International ISRC Agency codes - Former Yugoslavia before 2006 *)
      "ZB"
    ; (* RISA - South Africa *)
      "ZZ" (* International ISRC Agency codes - Worldwide *)
    ]

let compact number =
  Utils.clean number "[ -]" |> String.trim |> String.uppercase_ascii

let validate number =
  let number = compact number in

  if String.length number <> 12 then raise Invalid_length;

  (* Format: CC RRR YY NNNNN where
     CC is country (A-Z)
     RRR is registrant (A-Z0-9)
     YY is year (0-9)
     NNNNN is record (0-9) *)
  let is_upper_alpha c = c >= 'A' && c <= 'Z' in
  let is_digit c = c >= '0' && c <= '9' in
  let is_alnum c = is_upper_alpha c || is_digit c in

  let country = String.sub number 0 2 in
  let registrant = String.sub number 2 3 in
  let year = String.sub number 5 2 in
  let record = String.sub number 7 5 in

  if not (is_upper_alpha country.[0] && is_upper_alpha country.[1]) then
    raise Invalid_format;
  if
    not
      (is_alnum registrant.[0]
      && is_alnum registrant.[1]
      && is_alnum registrant.[2])
  then raise Invalid_format;
  if not (is_digit year.[0] && is_digit year.[1]) then raise Invalid_format;
  if
    not
      (is_digit record.[0]
      && is_digit record.[1]
      && is_digit record.[2]
      && is_digit record.[3]
      && is_digit record.[4])
  then raise Invalid_format;

  if not (List.mem country country_codes) then raise Invalid_component;

  number

let is_valid number =
  try
    ignore (validate number);
    true
  with Invalid_format | Invalid_length | Invalid_component -> false

let format ?(separator = "-") number =
  let number = compact number in
  let c = String.sub number 0 2 in
  let r = String.sub number 2 3 in
  let y = String.sub number 5 2 in
  let n = String.sub number 7 5 in
  c ^ separator ^ r ^ separator ^ y ^ separator ^ n
