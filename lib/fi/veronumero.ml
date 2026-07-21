(** Veronumero (Finnish individual tax number).

    The Veronumero an individual tax number that is assigned to workers in the
    construction industry in Finland. The number is separate from the HETU and
    is a 12 digit number without any embedded information such as birth dates.

    More information:
    - https://www.vero.fi/en/detailed-guidance/guidance/48791/individual_tax_numbers__instructions_fo/
    - https://prosentti.vero.fi/Veronumerorekisteri/Tarkistus/VeronumeronTarkistus.aspx
*)

open Tools

exception Invalid_format
exception Invalid_length

let compact number = Utils.clean number " " |> String.trim

let validate number =
  let number = compact number in
  if not (Utils.is_digits number) then raise Invalid_format;
  if String.length number <> 12 then raise Invalid_length;
  (* there is no known check digit validation *)
  number

let is_valid number =
  try
    ignore (validate number);
    true
  with Invalid_format | Invalid_length -> false
