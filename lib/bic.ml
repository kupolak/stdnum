(** BIC (ISO 9362 Business identifier codes).

    An ISO 9362 identifier (also: BIC, BEI, or SWIFT code) uniquely
    identifies an institution. They are commonly used to route financial
    transactions.

    The code consists of a 4 letter institution code, a 2 letter country code,
    and a 2 character location code, optionally followed by a three character
    branch code.

    More information:
    - https://en.wikipedia.org/wiki/ISO_9362 *)

open Tools

exception Invalid_format
exception Invalid_length
exception Invalid_component

(* Valid BIC country codes are ISO 3166-1 alpha-2 with the addition of
   XK for the Republic of Kosovo *)
let country_codes =
  [
    "AD"
  ; "AE"
  ; "AF"
  ; "AG"
  ; "AI"
  ; "AL"
  ; "AM"
  ; "AO"
  ; "AQ"
  ; "AR"
  ; "AS"
  ; "AT"
  ; "AU"
  ; "AW"
  ; "AX"
  ; "AZ"
  ; "BA"
  ; "BB"
  ; "BD"
  ; "BE"
  ; "BF"
  ; "BG"
  ; "BH"
  ; "BI"
  ; "BJ"
  ; "BL"
  ; "BM"
  ; "BN"
  ; "BO"
  ; "BQ"
  ; "BR"
  ; "BS"
  ; "BT"
  ; "BV"
  ; "BW"
  ; "BY"
  ; "BZ"
  ; "CA"
  ; "CC"
  ; "CD"
  ; "CF"
  ; "CG"
  ; "CH"
  ; "CI"
  ; "CK"
  ; "CL"
  ; "CM"
  ; "CN"
  ; "CO"
  ; "CR"
  ; "CU"
  ; "CV"
  ; "CW"
  ; "CX"
  ; "CY"
  ; "CZ"
  ; "DE"
  ; "DJ"
  ; "DK"
  ; "DM"
  ; "DO"
  ; "DZ"
  ; "EC"
  ; "EE"
  ; "EG"
  ; "EH"
  ; "ER"
  ; "ES"
  ; "ET"
  ; "FI"
  ; "FJ"
  ; "FK"
  ; "FM"
  ; "FO"
  ; "FR"
  ; "GA"
  ; "GB"
  ; "GD"
  ; "GE"
  ; "GF"
  ; "GG"
  ; "GH"
  ; "GI"
  ; "GL"
  ; "GM"
  ; "GN"
  ; "GP"
  ; "GQ"
  ; "GR"
  ; "GS"
  ; "GT"
  ; "GU"
  ; "GW"
  ; "GY"
  ; "HK"
  ; "HM"
  ; "HN"
  ; "HR"
  ; "HT"
  ; "HU"
  ; "ID"
  ; "IE"
  ; "IL"
  ; "IM"
  ; "IN"
  ; "IO"
  ; "IQ"
  ; "IR"
  ; "IS"
  ; "IT"
  ; "JE"
  ; "JM"
  ; "JO"
  ; "JP"
  ; "KE"
  ; "KG"
  ; "KH"
  ; "KI"
  ; "KM"
  ; "KN"
  ; "KP"
  ; "KR"
  ; "KW"
  ; "KY"
  ; "KZ"
  ; "LA"
  ; "LB"
  ; "LC"
  ; "LI"
  ; "LK"
  ; "LR"
  ; "LS"
  ; "LT"
  ; "LU"
  ; "LV"
  ; "LY"
  ; "MA"
  ; "MC"
  ; "MD"
  ; "ME"
  ; "MF"
  ; "MG"
  ; "MH"
  ; "MK"
  ; "ML"
  ; "MM"
  ; "MN"
  ; "MO"
  ; "MP"
  ; "MQ"
  ; "MR"
  ; "MS"
  ; "MT"
  ; "MU"
  ; "MV"
  ; "MW"
  ; "MX"
  ; "MY"
  ; "MZ"
  ; "NA"
  ; "NC"
  ; "NE"
  ; "NF"
  ; "NG"
  ; "NI"
  ; "NL"
  ; "NO"
  ; "NP"
  ; "NR"
  ; "NU"
  ; "NZ"
  ; "OM"
  ; "PA"
  ; "PE"
  ; "PF"
  ; "PG"
  ; "PH"
  ; "PK"
  ; "PL"
  ; "PM"
  ; "PN"
  ; "PR"
  ; "PS"
  ; "PT"
  ; "PW"
  ; "PY"
  ; "QA"
  ; "RE"
  ; "RO"
  ; "RS"
  ; "RU"
  ; "RW"
  ; "SA"
  ; "SB"
  ; "SC"
  ; "SD"
  ; "SE"
  ; "SG"
  ; "SH"
  ; "SI"
  ; "SJ"
  ; "SK"
  ; "SL"
  ; "SM"
  ; "SN"
  ; "SO"
  ; "SR"
  ; "SS"
  ; "ST"
  ; "SV"
  ; "SX"
  ; "SY"
  ; "SZ"
  ; "TC"
  ; "TD"
  ; "TF"
  ; "TG"
  ; "TH"
  ; "TJ"
  ; "TK"
  ; "TL"
  ; "TM"
  ; "TN"
  ; "TO"
  ; "TR"
  ; "TT"
  ; "TV"
  ; "TW"
  ; "TZ"
  ; "UA"
  ; "UG"
  ; "UM"
  ; "US"
  ; "UY"
  ; "UZ"
  ; "VA"
  ; "VC"
  ; "VE"
  ; "VG"
  ; "VI"
  ; "VN"
  ; "VU"
  ; "WF"
  ; "WS"
  ; "XK"
  ; "YE"
  ; "YT"
  ; "ZA"
  ; "ZM"
  ; "ZW"
  ]

let country_code_set =
  let tbl = Hashtbl.create 256 in
  List.iter (fun cc -> Hashtbl.add tbl cc ()) country_codes;
  tbl

let compact number =
  Utils.clean number "[ \\-]" |> String.trim |> String.uppercase_ascii

let validate number =
  let number = compact number in
  let len = String.length number in
  if len <> 8 && len <> 11 then raise Invalid_length;

  (* Check format: 4 letters + 2 letters (country) + 2 alphanumeric + optional 3 alphanumeric *)
  let is_valid_format =
    len >= 8
    && Utils.is_alpha (String.sub number 0 4)
    && Utils.is_alpha (String.sub number 4 2)
    && Utils.is_alnum (String.sub number 6 2)
    && (len = 8 || Utils.is_alnum (String.sub number 8 3))
  in
  if not is_valid_format then raise Invalid_format;

  (* Check country code *)
  let country_code = String.sub number 4 2 in
  if not (Hashtbl.mem country_code_set country_code) then
    raise Invalid_component;

  number

let is_valid number =
  try
    ignore (validate number);
    true
  with Invalid_format | Invalid_length | Invalid_component -> false

let format number = compact number
