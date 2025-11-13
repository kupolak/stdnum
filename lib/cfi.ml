(** CFI (ISO 10962 Classification of Financial Instruments).

    The CFI is a 6-character code used to classify financial instruments. It is
    issued alongside an ISIN and describes category such as equity or future and
    category-specific properties such as underlying asset type or payment status.

    More information:
    - https://en.wikipedia.org/wiki/ISO_10962
    - https://www.iso.org/standard/73564.html
    - https://www.six-group.com/en/products-services/financial-information/data-standards.html *)

open Tools

exception Invalid_format
exception Invalid_length
exception Invalid_component

let compact number =
  Utils.clean number "[ -]" |> String.trim |> String.uppercase_ascii

let validate number =
  let number = compact number in

  (* Check that all characters are uppercase letters *)
  if not (String.for_all (fun c -> c >= 'A' && c <= 'Z') number) then
    raise Invalid_format;

  (* Check length: must be exactly 6 characters *)
  if String.length number <> 6 then raise Invalid_length;

  (* NOTE: Full validation would require a CFI database lookup to validate
     each position against the classification hierarchy. This would require:
     - Position 1: Category (E=Equities, D=Debt, etc.)
     - Position 2: Group (specific to category)
     - Positions 3-6: Attributes (specific to category and group)

     For now, we only validate the basic format. Full database validation
     would be added with a numdb module similar to the Python implementation. *)
  number

let is_valid number =
  try
    ignore (validate number);
    true
  with Invalid_format | Invalid_length | Invalid_component -> false
