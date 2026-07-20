(** CPJ (Cédula de Persona Jurídica, Costa Rica tax number).

    The Cédula de Persona Jurídica (CPJ) is an identifier of legal entities for
    tax purposes.

    This number consists of 10 digits, the first indicates the class of juridical
    person, followed by a 3 digit sequence number identifying the type of
    juridical person, followed by 6 digits sequence number assigned by Registro
    Nacional de la República de Costa Rica.

    More information:
    - https://www.hacienda.go.cr/consultapagos/ayuda_cedulas.htm
    - https://www.procomer.com/downloads/quiero/guia_solicitud_vuce.pdf (page 11)
    - https://rnpdigital.com/personas_juridicas/documentos/Consultas/Listado%20de%20Clases%20y%20Tipos%20Cedulas%20Juridicas.pdf
    - https://www.hacienda.go.cr/ATV/frmConsultaSituTributaria.aspx *)

open Tools

exception Invalid_format
exception Invalid_length
exception Invalid_component

let compact number =
  Utils.clean number "[ -]" |> String.trim |> String.uppercase_ascii

let validate number =
  let number = compact number in
  if String.length number <> 10 then raise Invalid_length;
  if not (Utils.is_digits number) then raise Invalid_format;
  
  let first_char = number.[0] in
  if first_char <> '2' && first_char <> '3' && first_char <> '4' && first_char <> '5' then
    raise Invalid_component;
    
  let typ = String.sub number 1 3 in
  if first_char = '2' && not (List.mem typ ["100"; "200"; "300"; "400"]) then
    raise Invalid_component;
    
  let class_three_types = [
    "002"; "003"; "004"; "005"; "006"; "007"; "008"; "009"; "010"; "011";
    "012"; "013"; "014"; "101"; "102"; "103"; "104"; "105"; "106"; "107";
    "108"; "109"; "110"
  ] in
  if first_char = '3' && not (List.mem typ class_three_types) then
    raise Invalid_component;
    
  if first_char = '4' && typ <> "000" then
    raise Invalid_component;
    
  if first_char = '5' && typ <> "001" then
    raise Invalid_component;
    
  number

let is_valid number =
  try
    ignore (validate number);
    true
  with Invalid_format | Invalid_length | Invalid_component -> false

let format number =
  let number = compact number in
  String.sub number 0 1 ^ "-" ^
  String.sub number 1 3 ^ "-" ^
  String.sub number 4 6
