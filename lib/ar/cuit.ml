(** CUIT (Código Único de Identificación Tributaria, Argentinian tax number).

    The CUIT is a taxpayer identification number used for VAT (IVA, Impuesto al
    Valor Agregado) and other taxes.

    More information:
    - https://es.wikipedia.org/wiki/Clave_Única_de_Identificación_Tributaria *)

open Tools

exception Invalid_format
exception Invalid_length
exception Invalid_component
exception Invalid_checksum

let compact number = Utils.clean number "[ -]" |> String.trim

let calc_check_digit number =
  let weights = [| 5; 4; 3; 2; 7; 6; 5; 4; 3; 2 |] in
  let sum = ref 0 in
  for i = 0 to 9 do
    let digit = int_of_char number.[i] - int_of_char '0' in
    sum := !sum + (weights.(i) * digit)
  done;
  let check = !sum mod 11 in
  let lookup = "012345678990" in
  String.make 1 lookup.[11 - check]

let validate number =
  let number = compact number in
  if String.length number <> 11 then raise Invalid_length;
  if not (Utils.is_digits number) then raise Invalid_format;

  let valid_types =
    [ "20"; "23"; "24"; "27"; "30"; "33"; "34"; "50"; "51"; "55" ]
  in
  let prefix = String.sub number 0 2 in
  if not (List.mem prefix valid_types) then raise Invalid_component;

  if calc_check_digit (String.sub number 0 10) <> String.sub number 10 1 then
    raise Invalid_checksum;

  number

let validate_result number =
  try Ok (validate number) with
  | Invalid_format -> Error Error.Invalid_format
  | Invalid_length -> Error Error.Invalid_length
  | Invalid_component -> Error Tools.Error.Invalid_component
  | Invalid_checksum -> Error Error.Invalid_checksum

let is_valid number = Result.is_ok (validate_result number)

let format number =
  let number = compact number in
  String.sub number 0 2 ^ "-" ^ String.sub number 2 8 ^ "-"
  ^ String.sub number 10 1
