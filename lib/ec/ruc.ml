(** RUC (Registro Único de Contribuyentes, Ecuadorian company tax number).

    The RUC is a tax identification number for legal entities. It has 13 digits
    where the third digit is a number denoting the type of entity. *)

open Tools

exception Invalid_format
exception Invalid_length
exception Invalid_component
exception Invalid_checksum

let compact number = Ci.compact number

let checksum number weights =
  let sum = ref 0 in
  let len = Array.length weights in
  for i = 0 to len - 1 do
    let digit = int_of_char number.[i] - int_of_char '0' in
    sum := !sum + (weights.(i) * digit)
  done;
  !sum mod 11

let validate_natural number =
  let len = String.length number in
  let last_3 = String.sub number (len - 3) 3 in
  if last_3 = "000" then raise Invalid_component;

  begin try ignore (Ci.validate (String.sub number 0 10)) with
  | Ci.Invalid_component -> raise Invalid_component
  | Ci.Invalid_checksum -> raise Invalid_checksum
  | Ci.Invalid_format -> raise Invalid_format
  | Ci.Invalid_length -> raise Invalid_length
  end;
  number

let validate_public number =
  let len = String.length number in
  let last_4 = String.sub number (len - 4) 4 in
  if last_4 = "0000" then raise Invalid_component;
  let weights = [| 3; 2; 7; 6; 5; 4; 3; 2; 1 |] in
  if checksum (String.sub number 0 9) weights <> 0 then raise Invalid_checksum;
  number

let validate_juridical number =
  let len = String.length number in
  let last_3 = String.sub number (len - 3) 3 in
  if last_3 = "000" then raise Invalid_component;
  let weights = [| 4; 3; 2; 7; 6; 5; 4; 3; 2; 1 |] in
  if checksum (String.sub number 0 10) weights <> 0 then raise Invalid_checksum;
  number

let validate number =
  let number = compact number in
  if String.length number <> 13 then raise Invalid_length;
  if not (Utils.is_digits number) then raise Invalid_format;

  let prov_code = String.sub number 0 2 in
  if
    (prov_code < "01" || prov_code > "24")
    && prov_code <> "30" && prov_code <> "50"
  then raise Invalid_component;

  let third = number.[2] in
  if third < '6' then validate_natural number
  else if third = '6' then
    try validate_public number
    with Invalid_component | Invalid_checksum -> validate_natural number
  else if third = '9' then
    try validate_public number
    with Invalid_component | Invalid_checksum -> validate_juridical number
  else raise Invalid_component

let validate_result number =
  try Ok (validate number) with
  | Invalid_format -> Error Error.Invalid_format
  | Invalid_length -> Error Error.Invalid_length
  | Invalid_component -> Error Tools.Error.Invalid_component
  | Invalid_checksum -> Error Error.Invalid_checksum

let is_valid number = Result.is_ok (validate_result number)
