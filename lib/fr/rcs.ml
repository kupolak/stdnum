(** RCS (French trade registration number for commercial companies).

    The RCS number (Registre du commerce et des sociétés) is given by INSEE to a
    company with commercial activity when created. It is required for most of
    administrative procedures.

    The number consists of "RCS" letters followed by name of the city where the
    company was registered followed by letter A for a retailer or B for society
    followed by the SIREN number

    More information:
    - https://entreprendre.service-public.fr/vosdroits/F31190
    - https://fr.wikipedia.org/wiki/Registre_du_commerce_et_des_soci%C3%A9t%C3%A9s_(France)
*)

open Tools

exception Invalid_format
exception Invalid_length
exception Invalid_checksum

let parse number =
  let number = Utils.clean number "" |> String.trim in
  let re =
    Str.regexp
      "^[ \t]*\\(RCS\\|rcs\\)[ \t]+\\(.+\\)[ \t]+\\([AB]\\)[ \t]*\\([0-9][0-9 \
       \t]*\\)[ \t]*$"
  in
  if Str.string_match re number 0 then
    let tag = Str.matched_group 1 number |> String.uppercase_ascii in
    let city = Str.matched_group 2 number in
    let letter = Str.matched_group 3 number |> String.uppercase_ascii in
    let siren_raw = Str.matched_group 4 number in
    let siren_compact = Siren.compact siren_raw in
    if String.length siren_compact = 9 then
      Some (tag, city, letter, siren_compact)
    else None
  else None

let compact number =
  match parse number with
  | Some (tag, city, letter, siren) ->
      Printf.sprintf "%s %s %s %s" tag city letter siren
  | None -> Utils.clean number "" |> String.trim |> String.uppercase_ascii

let validate number =
  match parse number with
  | Some (tag, city, letter, siren) ->
      let _ =
        try Siren.validate siren with
        | Siren.Invalid_format -> raise Invalid_format
        | Siren.Invalid_length -> raise Invalid_length
        | Siren.Invalid_checksum -> raise Invalid_checksum
      in
      Printf.sprintf "%s %s %s %s" tag city letter siren
  | None -> raise Invalid_format

let is_valid number =
  try
    ignore (validate number);
    true
  with Invalid_format | Invalid_length | Invalid_checksum -> false

let format number =
  match parse number with
  | Some (tag, city, letter, siren) ->
      Printf.sprintf "%s %s %s %s" tag city letter (Siren.format siren)
  | None -> raise Invalid_format

let to_siren number =
  match parse number with
  | Some (_, _, _, siren) -> siren
  | None -> raise Invalid_format
