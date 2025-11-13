(** VAT, MWST, TVA, IVA, TPV (Mehrwertsteuernummer, the Swiss VAT number).

    The Swiss VAT number is based on the UID but is followed by either "MWST"
    (Mehrwertsteuer, the German abbreviation for VAT), "TVA" (Taxe sur la valeur
    ajoutée in French), "IVA" (Imposta sul valore aggiunto in Italian) or "TPV"
    (Taglia sin la plivalur in Romanian).

    This module only supports the "new" format that was introduced in 2011 which
    completely replaced the "old" 6-digit format in 2014.

    More information:
    - https://www.ch.ch/en/value-added-tax-number-und-business-identification-number/
    - https://www.uid.admin.ch/ *)

exception Invalid_format
exception Invalid_length
exception Invalid_checksum
exception Invalid_component

let compact number = Uid.compact number

let validate number =
  let number = compact number in
  let len = String.length number in
  if len <> 15 && len <> 16 then raise Invalid_length;
  (* Validate the UID part (first 12 characters) *)
  (try ignore (Uid.validate (String.sub number 0 12)) with
  | Uid.Invalid_format -> raise Invalid_format
  | Uid.Invalid_checksum -> raise Invalid_checksum
  | Uid.Invalid_component -> raise Invalid_component
  | Uid.Invalid_length -> raise Invalid_length);
  (* Check the suffix *)
  let suffix = String.sub number 12 (len - 12) in
  if suffix <> "MWST" && suffix <> "TVA" && suffix <> "IVA" && suffix <> "TPV"
  then raise Invalid_component;
  number

let is_valid number =
  try
    ignore (validate number);
    true
  with
  | Invalid_format | Invalid_length | Invalid_checksum | Invalid_component ->
    false

let format number =
  let num = compact number in
  Uid.format (String.sub num 0 12)
  ^ " "
  ^ String.sub num 12 (String.length num - 12)
