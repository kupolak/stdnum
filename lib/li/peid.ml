(** PEID (Liechtenstein tax code for individuals and entities).

    The Personenidentifikationsnummer (PEID) is an numeric code up to 12 digits
    used to identify entities and individuals residing in Liechtenstein.

    More information:
    - https://www.oera.li/
    - https://www.oecd.org/tax/automatic-exchange/crs-implementation-and-assistance/tax-identification-numbers/LIECHTENSTEIN%20TIN.pdf
*)

open Tools

exception Invalid_format
exception Invalid_length

let remove_leading_zeros s =
  let len = String.length s in
  let rec loop i =
    if i < len && s.[i] = '0' then loop (i + 1) else String.sub s i (len - i)
  in
  let res = loop 0 in
  if res = "" && len > 0 then "0" else res

let compact number =
  Utils.clean number "[ .]" |> String.trim |> remove_leading_zeros

let validate number =
  let number = compact number in
  let len = String.length number in
  if len < 4 || len > 12 then raise Invalid_length;
  if not (Utils.is_digits number) then raise Invalid_format;
  number

let is_valid number =
  try
    ignore (validate number);
    true
  with Invalid_format | Invalid_length -> false
