(** CURP (Clave Única de Registro de Población, Mexican personal ID).

    The Clave Única de Registro de Población (Population Registry Code) is
    unique identifier for both citizens and residents of Mexico. The is an
    18-character alphanumeric that contains certain letters from the person's
    name, their gender and birth date and a check digit.

    More information:
    - https://en.wikipedia.org/wiki/CURP
    - https://www.gob.mx/curp/ *)

open Tools

exception Invalid_format
exception Invalid_length
exception Invalid_checksum
exception Invalid_component

let name_blacklist =
  [
    "BACA"
  ; "BAKA"
  ; "BUEI"
  ; "BUEY"
  ; "CACA"
  ; "CACO"
  ; "CAGA"
  ; "CAGO"
  ; "CAKA"
  ; "CAKO"
  ; "COGE"
  ; "COGI"
  ; "COJA"
  ; "COJE"
  ; "COJI"
  ; "COJO"
  ; "COLA"
  ; "CULO"
  ; "FALO"
  ; "FETO"
  ; "GETA"
  ; "GUEI"
  ; "GUEY"
  ; "JETA"
  ; "JOTO"
  ; "KACA"
  ; "KACO"
  ; "KAGA"
  ; "KAGO"
  ; "KAKA"
  ; "KAKO"
  ; "KOGE"
  ; "KOGI"
  ; "KOJA"
  ; "KOJE"
  ; "KOJI"
  ; "KOJO"
  ; "KOLA"
  ; "KULO"
  ; "LILO"
  ; "LOCA"
  ; "LOCO"
  ; "LOKA"
  ; "LOKO"
  ; "MAME"
  ; "MAMO"
  ; "MEAR"
  ; "MEAS"
  ; "MEON"
  ; "MIAR"
  ; "MION"
  ; "MOCO"
  ; "MOKO"
  ; "MULA"
  ; "MULO"
  ; "NACA"
  ; "NACO"
  ; "PEDA"
  ; "PEDO"
  ; "PENE"
  ; "PIPI"
  ; "PITO"
  ; "POPO"
  ; "PUTA"
  ; "PUTO"
  ; "QULO"
  ; "RATA"
  ; "ROBA"
  ; "ROBE"
  ; "ROBO"
  ; "RUIN"
  ; "SENO"
  ; "TETA"
  ; "VACA"
  ; "VAGA"
  ; "VAGO"
  ; "VAKA"
  ; "VUEI"
  ; "VUEY"
  ; "WUEI"
  ; "WUEY"
  ]

let valid_states =
  [
    "AS"
  ; "BC"
  ; "BS"
  ; "CC"
  ; "CH"
  ; "CL"
  ; "CM"
  ; "CS"
  ; "DF"
  ; "DG"
  ; "GR"
  ; "GT"
  ; "HG"
  ; "JC"
  ; "MC"
  ; "MN"
  ; "MS"
  ; "NE"
  ; "NL"
  ; "NT"
  ; "OC"
  ; "PL"
  ; "QR"
  ; "QT"
  ; "SL"
  ; "SP"
  ; "SR"
  ; "TC"
  ; "TL"
  ; "TS"
  ; "VZ"
  ; "YN"
  ; "ZS"
  ]

let compact number =
  Utils.clean number "[-_ ]" |> String.trim |> String.uppercase_ascii

let is_valid_date year month day =
  if year < 1 || month < 1 || month > 12 || day < 1 || day > 31 then false
  else
    let days_in_month =
      match month with
      | 4 | 6 | 9 | 11 -> 30
      | 2 ->
          let is_leap =
            (year mod 4 = 0 && year mod 100 <> 0) || year mod 400 = 0
          in
          if is_leap then 29 else 28
      | _ -> 31
    in
    day <= days_in_month

let get_birth_date number =
  let number = compact number in
  let year_str = String.sub number 4 2 in
  let month = int_of_string (String.sub number 6 2) in
  let day = int_of_string (String.sub number 8 2) in
  let year = int_of_string year_str in
  let year =
    if Utils.is_digits (String.sub number 16 1) then year + 1900
    else year + 2000
  in
  if not (is_valid_date year month day) then raise Invalid_component;
  (year, month, day)

let get_gender number =
  let number = compact number in
  match number.[10] with
  | 'H' -> "M"
  | 'M' -> "F"
  | _ -> raise Invalid_component

let alphabet = "0123456789ABCDEFGHIJKLMN&OPQRSTUVWXYZ"

let calc_check_digit number =
  let check = ref 0 in
  for i = 0 to 16 do
    let char_index =
      try String.index alphabet number.[i] with Not_found -> 0
    in
    check := !check + (char_index * (18 - i))
  done;
  string_of_int ((10 - (!check mod 10)) mod 10)

let validate ?(validate_check_digits = true) number =
  let number = compact number in
  if String.length number <> 18 then raise Invalid_length;
  let re =
    Str.regexp
      "^[A-Z][A-Z][A-Z][A-Z][0-9][0-9][0-9][0-9][0-9][0-9][A-Z][A-Z][A-Z][A-Z][A-Z][A-Z][0-9A-Z][0-9]$"
  in
  if not (Str.string_match re number 0) then raise Invalid_format;
  if List.mem (String.sub number 0 4) name_blacklist then
    raise Invalid_component;
  ignore (get_birth_date number);
  ignore (get_gender number);
  if not (List.mem (String.sub number 11 2) valid_states) then
    raise Invalid_component;
  if
    validate_check_digits
    && String.make 1 number.[17] <> calc_check_digit number
  then raise Invalid_checksum;
  number

let validate_result ?validate_check_digits number =
  try Ok (validate ?validate_check_digits number) with
  | Invalid_format -> Error Error.Invalid_format
  | Invalid_length -> Error Error.Invalid_length
  | Invalid_checksum -> Error Error.Invalid_checksum
  | Invalid_component -> Error Tools.Error.Invalid_component

let is_valid ?validate_check_digits number =
  Result.is_ok (validate_result ?validate_check_digits number)
