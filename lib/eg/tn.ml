(** Tax Registration Number (الرقم الضريبي, Egypt tax number).

    This number consists of 9 digits, usually separated into three groups using
    hyphens to make it easier to read, like XXX-XXX-XXX.

    More information:
    - https://emsp.mts.gov.eg:8181/EMDB-web/faces/authoritiesandcompanies/authority/website/SearchAuthority.xhtml?lang=en
*)

open Tools

exception Invalid_format
exception Invalid_length

let normalize_arabic number =
  let pairs =
    [
      ("٠", "0")
    ; ("١", "1")
    ; ("٢", "2")
    ; ("٣", "3")
    ; ("٤", "4")
    ; ("٥", "5")
    ; ("٦", "6")
    ; ("٧", "7")
    ; ("٨", "8")
    ; ("٩", "9")
    ; ("۰", "0")
    ; ("۱", "1")
    ; ("۲", "2")
    ; ("۳", "3")
    ; ("۴", "4")
    ; ("۵", "5")
    ; ("۶", "6")
    ; ("۷", "7")
    ; ("۸", "8")
    ; ("۹", "9")
    ]
  in
  List.fold_left
    (fun acc (s, by) -> Str.global_replace (Str.regexp_string s) by acc)
    number pairs

let compact number =
  let cleaned = Utils.clean number "[ \\/-]" |> String.trim in
  normalize_arabic cleaned

let validate number =
  let number = compact number in
  if not (Utils.is_digits number) then raise Invalid_format;
  if String.length number <> 9 then raise Invalid_length;
  number

let validate_result number =
  try Ok (validate number) with
  | Invalid_format -> Error Error.Invalid_format
  | Invalid_length -> Error Error.Invalid_length

let is_valid number =
  try
    ignore (validate number);
    true
  with Invalid_format | Invalid_length -> false

let format number =
  let number = compact number in
  String.sub number 0 3 ^ "-" ^ String.sub number 3 3 ^ "-"
  ^ String.sub number 6 3
