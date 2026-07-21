(** NINEA (Numéro d'Identification Nationale des Entreprises et Associations,
    Senegal tax number).

    The National Identification Number for Businesses and Associations (NINEA)
    is a unique tax identifier for tax purposes in Senegal.

    This number consists of 7 digits and is usually followed by a 3 digit tax
    identification code called COFI (Code d’Identification Fiscale) that is used
    to indicate the company's tax status and legal structure.

    More information:
    - https://www.wikiprocedure.com/index.php/Senegal%5F-_Obtain_a_Tax_Identification_Number
    - https://nkac-audit.com/comprendre-le-ninea-votre-guide-de-lecture-simplifie/
    - https://www.creationdentreprise.sn/rechercher-une-societe
    - https://www.dci-sn.sn/index.php/obtenir-son-ninea
    - https://e-ninea.ansd.sn/search_annuaire *)

open Tools

exception Invalid_format
exception Invalid_length
exception Invalid_checksum
exception Invalid_component

let compact number =
  Utils.clean number "[ -/,]" |> String.uppercase_ascii |> String.trim

let validate_cofi cofi =
  match cofi.[0] with
  | '0' .. '2' -> (
      match cofi.[1] with
      | 'A' .. 'H' | 'J' .. 'N' | 'P' .. 'W' | 'Z' -> (
          match cofi.[2] with '0' .. '9' -> () | _ -> raise Invalid_component)
      | _ -> raise Invalid_component)
  | _ -> raise Invalid_component

let checksum number =
  let number =
    let len = String.length number in
    if len < 9 then String.make (9 - len) '0' ^ number else number
  in
  let weights = [| 1; 2; 1; 2; 1; 2; 1; 2; 1 |] in
  let sum = ref 0 in
  for i = 0 to 8 do
    let n = int_of_char number.[i] - int_of_char '0' in
    sum := !sum + (n * weights.(i))
  done;
  !sum mod 10

let validate number =
  let number = compact number in
  let len = String.length number in
  let base_number, cofi =
    if len > 9 then
      (String.sub number 0 (len - 3), String.sub number (len - 3) 3)
    else (number, "")
  in
  let base_len = String.length base_number in
  if base_len <> 7 && base_len <> 9 then raise Invalid_length;
  if not (Utils.is_digits base_number) then raise Invalid_format;
  if String.length cofi > 0 then validate_cofi cofi;
  if checksum base_number <> 0 then raise Invalid_checksum;
  base_number ^ cofi

let validate_result number =
  try Ok (validate number) with
  | Invalid_format -> Error Error.Invalid_format
  | Invalid_length -> Error Error.Invalid_length
  | Invalid_checksum -> Error Error.Invalid_checksum
  | Invalid_component -> Error Tools.Error.Invalid_component

let is_valid number = Result.is_ok (validate_result number)

let format number =
  let number = compact number in
  let len = String.length number in
  if len = 7 || len = 9 then number
  else String.sub number 0 (len - 3) ^ " " ^ String.sub number (len - 3) 3
