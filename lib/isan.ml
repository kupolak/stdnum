(** ISAN (International Standard Audiovisual Number).

    The ISAN (International Standard Audiovisual Number) is used to identify
    audiovisual works.

    The number is hexadecimal and can consists of at least a root identifier,
    and an episode or part. After that an optional check digit, optional version
    and optionally another check digit can be provided. The check digits are
    validated using the ISO 7064 Mod 37, 36 algorithm.

    More information:
    - https://en.wikipedia.org/wiki/International_Standard_Audiovisual_Number *)

open Tools

exception Invalid_format
exception Invalid_length
exception Invalid_checksum

let split number =
  let number =
    Utils.clean number "[ -]" |> String.trim |> String.uppercase_ascii
  in
  let len = String.length number in
  if len = 17 || len = 26 then
    ( String.sub number 0 12
    , String.sub number 12 4
    , String.sub number 16 1
    , (if len = 26 then String.sub number 17 8 else "")
    , if len = 26 then String.sub number 25 1 else "" )
  else if len > 16 then
    ( String.sub number 0 12
    , String.sub number 12 4
    , ""
    , String.sub number 16 8
    , if len > 24 then String.sub number 24 (len - 24) else "" )
  else
    ( String.sub number 0 12
    , (if len >= 16 then String.sub number 12 4
       else String.sub number 12 (len - 12))
    , (if len > 16 then String.sub number 16 (len - 16) else "")
    , ""
    , "" )

let compact ?(strip_check_digits = true) number =
  let root, episode, check1, version, check2 = split number in
  let check1 = if strip_check_digits then "" else check1 in
  let check2 = if strip_check_digits then "" else check2 in
  root ^ episode ^ check1 ^ version ^ check2

let validate ?(strip_check_digits = false) ?(add_check_digits = false) number =
  let root, episode, check1, version, check2 = split number in

  let is_hex_char c = String.contains "0123456789ABCDEF" c in
  let check_hex s =
    let rec aux i =
      if i >= String.length s then true
      else if is_hex_char s.[i] then aux (i + 1)
      else false
    in
    aux 0
  in
  if not (check_hex (root ^ episode ^ version)) then raise Invalid_format;

  if
    String.length root <> 12
    || String.length episode <> 4
    || (String.length check1 <> 0 && String.length check1 <> 1)
    || (String.length version <> 0 && String.length version <> 8)
    || (String.length check2 <> 0 && String.length check2 <> 1)
  then raise Invalid_length;

  let check1 = if strip_check_digits then "" else check1 in
  let check2 = if strip_check_digits then "" else check2 in

  if check1 <> "" then begin
    try ignore (Iso7064.Mod_37_36.validate (root ^ episode ^ check1)) with
    | Iso7064.Mod_37_36.Invalid_checksum -> raise Invalid_checksum
    | Iso7064.Mod_37_36.Invalid_format -> raise Invalid_format
  end;
  if check2 <> "" then begin
    try
      ignore (Iso7064.Mod_37_36.validate (root ^ episode ^ version ^ check2))
    with
    | Iso7064.Mod_37_36.Invalid_checksum -> raise Invalid_checksum
    | Iso7064.Mod_37_36.Invalid_format -> raise Invalid_format
  end;

  let check1 =
    if add_check_digits && check1 = "" then
      String.make 1 (Iso7064.Mod_37_36.calc_check_digit (root ^ episode))
    else check1
  in
  let check2 =
    if add_check_digits && check2 = "" && version <> "" then
      String.make 1
        (Iso7064.Mod_37_36.calc_check_digit (root ^ episode ^ version))
    else check2
  in
  root ^ episode ^ check1 ^ version ^ check2

let validate_result ?strip_check_digits ?add_check_digits number =
  try Ok (validate ?strip_check_digits ?add_check_digits number) with
  | Invalid_format -> Error Tools.Error.Invalid_format
  | Invalid_length -> Error Tools.Error.Invalid_length
  | Invalid_checksum -> Error Tools.Error.Invalid_checksum

let is_valid number = Result.is_ok (validate_result number)

let format ?(separator = "-") ?(strip_check_digits = false)
    ?(add_check_digits = true) number =
  let root, episode, check1, version, check2 = split number in
  let check1 = if strip_check_digits then "" else check1 in
  let check2 = if strip_check_digits then "" else check2 in

  let check1 =
    if add_check_digits && check1 = "" then
      String.make 1 (Iso7064.Mod_37_36.calc_check_digit (root ^ episode))
    else check1
  in
  let check2 =
    if add_check_digits && check2 = "" && version <> "" then
      String.make 1
        (Iso7064.Mod_37_36.calc_check_digit (root ^ episode ^ version))
    else check2
  in

  let parts = ref [] in
  for i = 0 to 2 do
    parts := String.sub root (i * 4) 4 :: !parts
  done;
  let parts = List.rev !parts in
  let parts = parts @ [ episode ] in
  let parts = if check1 <> "" then parts @ [ check1 ] else parts in
  let parts =
    if version <> "" then
      parts @ [ String.sub version 0 4; String.sub version 4 4 ]
    else parts
  in
  let parts = if check2 <> "" then parts @ [ check2 ] else parts in
  String.concat separator parts

let to_urn number = "URN:ISAN:" ^ format ~add_check_digits:true number

let to_xml number =
  let formatted =
    format ~separator:"-" ~strip_check_digits:true ~add_check_digits:false
      number
  in
  let root = String.sub formatted 0 14 in
  let episode = String.sub formatted 15 4 in
  let version =
    if String.length formatted > 19 then
      String.sub formatted 20 (String.length formatted - 20)
    else ""
  in
  if version = "" then
    Printf.sprintf "<ISAN root=\"%s\" episode=\"%s\" />" root episode
  else
    Printf.sprintf "<ISAN root=\"%s\" episode=\"%s\" version=\"%s\" />" root
      episode version
