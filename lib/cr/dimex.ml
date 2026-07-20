(** CR (Cédula de Residencia, Costa Rica foreigners ID number).

    The Cédula de Residencia (CR), also know as DIMEX or Documento de
    Identificación Migratorio para Extranjeros, is an identifier of foreigners in
    Costa Rica.

    This number consists of 11 or 12 digits in the form 1NNN-CC...C-EE...E where
    NNN represents the code of the country the foreigner comes from as specified
    by Costa Rica's Dirección General de Migración y Extranjería, CC...C is a
    sequence telling how many Cédula de Residencia have been issued in total and
    EE...E is a sequence telling how many Cédula de Residencia have been issued
    for that particular foreign country.

    More information:
    - https://www.hacienda.go.cr/consultapagos/ayuda_cedulas.htm
    - https://www.procomer.com/downloads/quiero/guia_solicitud_vuce.pdf (page 12)
    - https://www.hacienda.go.cr/ATV/frmConsultaSituTributaria.aspx *)

open Tools

exception Invalid_format
exception Invalid_length
exception Invalid_component

let compact number =
  Utils.clean number "[ -]" |> String.trim |> String.uppercase_ascii

let validate number =
  let number = compact number in
  let len = String.length number in
  if len <> 11 && len <> 12 then raise Invalid_length;
  if not (Utils.is_digits number) then raise Invalid_format;
  if number.[0] <> '1' then raise Invalid_component;
  number

let is_valid number =
  try
    ignore (validate number);
    true
  with Invalid_format | Invalid_length | Invalid_component -> false

let format number =
  compact number
