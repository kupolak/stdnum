(** NCF (Números de Comprobante Fiscal, Dominican Republic receipt number).

    The NCF is used to number invoices and other documents for the purpose of tax
    filing. The e-CF (Comprobante Fiscal Electrónico) is used together with a
    digital certificate for the same purpose. The number is either 19, 11 or 13
    (e-CF) digits long.

    The 19 digit number starts with a letter (A or P) to indicate that the number
    was assigned by the taxpayer or the DGII, followed a 2-digit business unit
    number, a 3-digit location number, a 3-digit mechanism identifier, a 2-digit
    document type and a 8-digit serial number.

    The 11 digit number always starts with a B followed a 2-digit document type
    and a 7-digit serial number.

    The 13 digit e-CF starts with an E followed a 2-digit document type and an
    8-digit serial number.

    More information:
    - https://www.dgii.gov.do/
    - https://dgii.gov.do/workshopProveedoresTI-eCE/Documents/Norma05-19.pdf *)

open Tools

exception Invalid_format
exception Invalid_length
exception Invalid_component

let compact number =
  Utils.clean number "[ ]" |> String.uppercase_ascii |> String.trim

(* The following document types are known *)
let ncf_document_types =
  [
    "01" (* invoices for fiscal declaration (or tax reporting) *)
  ; "02" (* invoices for final consumer *)
  ; "03" (* debit note *)
  ; "04" (* credit note (refunds) *)
  ; "11" (* informal supplier invoices (purchases) *)
  ; "12" (* single income invoices *)
  ; "13" (* minor expenses invoices (purchases) *)
  ; "14" (* invoices for special customers (tourists, free zones) *)
  ; "15" (* invoices for the government *)
  ; "16" (* invoices for export *)
  ; "17" (* invoices for payments abroad *)
  ]

let ecf_document_types =
  [
    "31" (* invoices for fiscal declaration (or tax reporting) *)
  ; "32" (* invoices for final consumer *)
  ; "33" (* debit note *)
  ; "34" (* credit note (refunds) *)
  ; "41" (* supplier invoices (purchases) *)
  ; "43" (* minor expenses invoices (purchases) *)
  ; "44" (* invoices for special customers (tourists, free zones) *)
  ; "45" (* invoices for the government *)
  ; "46" (* invoices for exports *)
  ; "47" (* invoices for foreign payments *)
  ]

let validate number =
  let number = compact number in
  let len = String.length number in
  if len = 13 then (
    if number.[0] <> 'E' || not (Utils.is_digits (String.sub number 1 12)) then
      raise Invalid_format;
    let doc_type = String.sub number 1 2 in
    if not (List.mem doc_type ecf_document_types) then raise Invalid_component)
  else if len = 11 then (
    if number.[0] <> 'B' || not (Utils.is_digits (String.sub number 1 10)) then
      raise Invalid_format;
    let doc_type = String.sub number 1 2 in
    if not (List.mem doc_type ncf_document_types) then raise Invalid_component)
  else if len = 19 then (
    if
      (number.[0] <> 'A' && number.[0] <> 'P')
      || not (Utils.is_digits (String.sub number 1 18))
    then raise Invalid_format;
    let doc_type = String.sub number 9 2 in
    if not (List.mem doc_type ncf_document_types) then raise Invalid_component)
  else raise Invalid_length;
  number

let is_valid number =
  try
    ignore (validate number);
    true
  with Invalid_format | Invalid_length | Invalid_component -> false
