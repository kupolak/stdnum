open Tools

exception Invalid_length
exception Invalid_format

(* Valid office codes (provinces and cities) *)
let offices =
  [|
     "01"
   ; "02"
   ; "03"
   ; "04"
   ; "05"
   ; "06"
   ; "07"
   ; "08"
   ; "09"
   ; "10"
   ; "11"
   ; "12"
   ; "13"
   ; "14"
   ; "15"
   ; "16"
   ; "17"
   ; "18"
   ; "19"
   ; "20"
   ; "21"
   ; "22"
   ; "23"
   ; "24"
   ; "25"
   ; "26"
   ; "27"
   ; "28"
   ; "29"
   ; "30"
   ; "31"
   ; "32"
   ; "33"
   ; "34"
   ; "35"
   ; "36"
   ; "37"
   ; "38"
   ; "39"
   ; "40"
   ; "41"
   ; "42"
   ; "43"
   ; "44"
   ; "45"
   ; "46"
   ; "47"
   ; "48"
   ; "49"
   ; "50"
   ; "51"
   ; "52"
   ; "53"
   ; "54"
   ; "55"
   ; "56"
  |]

(* Valid activity keys *)
let activity_keys =
  [|
     "A1"
   ; "B1"
   ; "B9"
   ; "B0"
   ; "BA"
   ; "C1"
   ; "DA"
   ; "EC"
   ; "F1"
   ; "V1"
   ; "A7"
   ; "AT"
   ; "B7"
   ; "BT"
   ; "C7"
   ; "DB"
   ; "E7"
   ; "M7"
   ; "OA"
   ; "OB"
   ; "OE"
   ; "OV"
   ; "V7"
   ; "B6"
   ; "A2"
   ; "A6"
   ; "A9"
   ; "A0"
   ; "AC"
   ; "AV"
   ; "AW"
   ; "AX"
   ; "H1"
   ; "H2"
   ; "H4"
   ; "H6"
   ; "H9"
   ; "H0"
   ; "HD"
   ; "HH"
   ; "H7"
   ; "H8"
   ; "HB"
   ; "HF"
   ; "HI"
   ; "HJ"
   ; "HK"
   ; "HL"
   ; "HM"
   ; "HN"
   ; "HT"
   ; "HU"
   ; "HV"
   ; "HX"
   ; "HZ"
   ; "OH"
   ; "HA"
   ; "HC"
   ; "HE"
   ; "HP"
   ; "HQ"
   ; "HR"
   ; "HS"
   ; "HW"
   ; "T1"
   ; "OT"
   ; "T7"
   ; "TT"
   ; "L1"
   ; "L2"
   ; "L0"
   ; "L3"
   ; "L7"
   ; "AF"
   ; "DF"
   ; "DM"
   ; "DP"
   ; "OR"
   ; "PF"
   ; "RF"
   ; "VD"
  |]

let compact number =
  Utils.clean number "" |> String.uppercase_ascii |> String.trim

let is_in_array arr value = Array.exists (fun x -> x = value) arr

let validate number =
  let number = compact number in
  if String.length number <> 13 then raise Invalid_length;

  (* Check ES prefix *)
  if String.sub number 0 2 <> "ES" then raise Invalid_format;

  (* Check 000 after ES *)
  if String.sub number 2 3 <> "000" then raise Invalid_format;

  (* Check office code (positions 5-6) *)
  let office = String.sub number 5 2 in
  if not (is_in_array offices office) then raise Invalid_format;

  (* Check activity key (positions 7-8) *)
  let activity = String.sub number 7 2 in
  if not (is_in_array activity_keys activity) then raise Invalid_format;

  (* Check digits at positions 9-11 *)
  let digits = String.sub number 9 3 in
  if not (Utils.is_digits digits) then raise Invalid_format;

  (* Check last character is alphabetic *)
  let last_char = number.[12] in
  if
    not
      ((last_char >= 'A' && last_char <= 'Z')
      || (last_char >= 'a' && last_char <= 'z'))
  then raise Invalid_format;

  number

let is_valid number =
  try
    ignore (validate number);
    true
  with Invalid_format | Invalid_length -> false
