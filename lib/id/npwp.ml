(** NPWP (Nomor Pokok Wajib Pajak, Indonesian VAT Number).

    The Nomor Pokok Wajib Pajak (NPWP) is assigned to organisations and
    individuals (families) by the Indonesian Tax Office after registration by
    the tax payers.

    The number consists of 16 digits and is either a NIK (Nomor Induk
    Kependudukan) or a number that starts with a 0, followed by 2 digits that
    denote the type of entity, 6 digits to identify the tax payer, a check digit
    over the first 8 digits followed by 3 digits to identify the local tax
    office and 3 digits for branch code.

    This module also accepts the old 15 digit format which is just the 16 digit
    format without the starting 0.

    More information:
    - https://www.oecd.org/tax/automatic-exchange/crs-implementation-and-assistance/tax-identification-numbers/Indonesia-TIN.pdf
    - https://metacpan.org/pod/Business::ID::NPWP
    - https://wiki.scn.sap.com/wiki/display/CRM/Indonesia *)

open Tools

exception Invalid_format
exception Invalid_length
exception Invalid_checksum
exception Invalid_component

let compact number = Utils.clean number "[ -.]" |> String.trim

let validate number =
  let number = compact number in
  if not (Utils.is_digits number) then raise Invalid_format;
  let len = String.length number in
  if len = 15 then
    let () =
      try ignore (Luhn.validate (String.sub number 0 9))
      with Luhn.Invalid_checksum -> raise Invalid_checksum
    in
    number
  else if len = 16 then
    if not (String.starts_with ~prefix:"0" number) then
      try Nik.validate number with
      | Nik.Invalid_format -> raise Invalid_format
      | Nik.Invalid_length -> raise Invalid_length
      | Nik.Invalid_component -> raise Invalid_component
    else
      let () =
        try ignore (Luhn.validate (String.sub number 0 10))
        with Luhn.Invalid_checksum -> raise Invalid_checksum
      in
      number
  else raise Invalid_length

let is_valid number =
  try
    ignore (validate number);
    true
  with
  | Invalid_format | Invalid_length | Invalid_checksum | Invalid_component ->
    false

let format number =
  let number = compact number in
  String.sub number 0 2 ^ "." ^ String.sub number 2 3 ^ "."
  ^ String.sub number 5 3 ^ "." ^ String.sub number 8 1 ^ "-"
  ^ String.sub number 9 3 ^ "."
  ^ String.sub number 12 (String.length number - 12)
