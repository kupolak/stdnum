(** n° TVA (taxe sur la valeur ajoutée, Monacan VAT number).

    For VAT purposes Monaco is treated as territory of France. The number is
    also validated the same as the French TVA, except that it is not based on a
    French SIREN. *)

exception Invalid_component

let compact number = "FR" ^ Fr.Tva.compact number

let validate number =
  let number = Fr.Tva.validate number in
  if String.sub number 2 3 <> "000" then raise Invalid_component;
  "FR" ^ number

let is_valid number =
  try
    ignore (validate number);
    true
  with
  | Fr.Tva.Invalid_format | Fr.Tva.Invalid_length | Fr.Tva.Invalid_checksum
  | Fr.Tva.Invalid_component | Invalid_component
  ->
    false
