(** ISIN (International Securities Identification Number).

    The ISIN is a 12-character alpha-numerical code specified in ISO 6166 used
    to identify exchange listed securities such as bonds, commercial paper,
    stocks and warrants. The number is formed of a two-letter country code, a
    nine character national security identifier and a single check digit.

    More information:
    - https://en.wikipedia.org/wiki/International_Securities_Identification_Number
*)

open Tools

exception Invalid_format
exception Invalid_length
exception Invalid_component
exception Invalid_checksum

let iso_3166_1_country_codes =
  [
    "AD"
  ; "AE"
  ; "AF"
  ; "AG"
  ; "AI"
  ; "AL"
  ; "AM"
  ; "AN"
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
  ; "CS"
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
  ; "YE"
  ; "YT"
  ; "ZA"
  ; "ZM"
  ; "ZW"
  ]

let country_codes =
  iso_3166_1_country_codes
  @ [
      "EU"
    ; (* European Union *)
      "QS"
    ; (* internally used by Euroclear France / temporarily assigned in Germany *)
      "QT"
    ; (* internally used in Switzerland *)
      "XA"
    ; (* CUSIP Global Services substitute agencies *)
      "XB"
    ; (* NSD Russia substitute agencies *)
      "XC"
    ; (* WM Datenservice Germany substitute agencies *)
      "XD"
    ; (* SIX Telekurs substitute agencies *)
      "XF"
    ; (* internally assigned, not unique numbers *)
      "XK"
    ; (* temporary country code for Kosovo *)
      "XS" (* international securities *)
    ]

let alphabet = "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ"

let compact number =
  Utils.clean number "[ ]" |> String.trim |> String.uppercase_ascii

let calc_check_digit number =
  let char_value c =
    let rec find i =
      if i >= String.length alphabet then raise Not_found
      else if alphabet.[i] = c then i
      else find (i + 1)
    in
    string_of_int (find 0)
  in

  let numeric_str =
    let buf = Buffer.create (String.length number * 2) in
    String.iter (fun c -> Buffer.add_string buf (char_value c)) number;
    Buffer.contents buf
  in

  let numeric_len = String.length numeric_str in
  let sum = ref 0 in
  for i = 0 to numeric_len - 1 do
    let pos = numeric_len - 1 - i in
    let digit = int_of_char numeric_str.[pos] - int_of_char '0' in
    let weight = if i mod 2 = 0 then 2 else 1 in
    let doubled = digit * weight in
    let digit_sum = (doubled / 10) + (doubled mod 10) in
    sum := !sum + digit_sum
  done;
  let check = (10 - (!sum mod 10)) mod 10 in
  string_of_int check

let validate number =
  let number = compact number in

  let is_valid_char c = String.contains alphabet c in
  let all_valid =
    let rec check i =
      if i >= String.length number then true
      else if is_valid_char number.[i] then check (i + 1)
      else false
    in
    check 0
  in
  if not all_valid then raise Invalid_format;

  if String.length number <> 12 then raise Invalid_length;

  let country = String.sub number 0 2 in
  if not (List.mem country country_codes) then raise Invalid_component;

  let check_digit = String.sub number 11 1 in
  let number_part = String.sub number 0 11 in
  if calc_check_digit number_part <> check_digit then raise Invalid_checksum;

  number

let is_valid number =
  try
    ignore (validate number);
    true
  with
  | Invalid_format | Invalid_length | Invalid_component | Invalid_checksum ->
    false

let from_natid country_code number =
  let country_code = String.uppercase_ascii country_code in
  let number = compact number in
  let pad_len = max 0 (9 - String.length number) in
  let padded = String.make pad_len '0' ^ number in
  let isin_base = country_code ^ padded in
  isin_base ^ calc_check_digit isin_base
