(** St.-Nr. (Steuernummer, German tax number).

    The Steuernummer (St.-Nr.) is a tax number assigned by regional tax offices
    to taxable individuals and organisations. The number is being replaced by the
    Steuerliche Identifikationsnummer (IdNr).

    The number has 10 or 11 digits for the regional form (per Bundesland) and 13
    digits for the number that is unique within Germany. *)

open Tools

exception Invalid_format
exception Invalid_length
exception Invalid_component

type region =
  | Baden_Wuerttemberg
  | Bayern
  | Berlin
  | Brandenburg
  | Bremen
  | Hamburg
  | Hessen
  | Mecklenburg_Vorpommern
  | Niedersachsen
  | Nordrhein_Westfalen
  | Rheinland_Pfalz
  | Saarland
  | Sachsen
  | Sachsen_Anhalt
  | Schleswig_Holstein
  | Thueringen

(* Format patterns: F=BUFA, B=district, U=serial, P=check digit *)
type format_pattern = { regional : string; country : string }

let region_formats =
  [
    (Baden_Wuerttemberg, { regional = "FFBBBUUUUP"; country = "28FF0BBBUUUUP" })
  ; (Bayern, { regional = "FFFBBBUUUUP"; country = "9FFF0BBBUUUUP" })
  ; (Berlin, { regional = "FFBBBUUUUP"; country = "11FF0BBBUUUUP" })
  ; (Brandenburg, { regional = "0FFBBBUUUUP"; country = "30FF0BBBUUUUP" })
  ; (Bremen, { regional = "FFBBBUUUUP"; country = "24FF0BBBUUUUP" })
  ; (Hamburg, { regional = "FFBBBUUUUP"; country = "22FF0BBBUUUUP" })
  ; (Hessen, { regional = "0FFBBBUUUUP"; country = "26FF0BBBUUUUP" })
  ; ( Mecklenburg_Vorpommern
    , { regional = "0FFBBBUUUUP"; country = "40FF0BBBUUUUP" } )
  ; (Niedersachsen, { regional = "FFBBBUUUUP"; country = "23FF0BBBUUUUP" })
  ; ( Nordrhein_Westfalen
    , { regional = "FFFBBBBUUUP"; country = "5FFF0BBBBUUUP" } )
  ; (Rheinland_Pfalz, { regional = "FFBBBUUUUP"; country = "27FF0BBBUUUUP" })
  ; (Saarland, { regional = "0FFBBBUUUUP"; country = "10FF0BBBUUUUP" })
  ; (Sachsen, { regional = "2FFBBBUUUUP"; country = "32FF0BBBUUUUP" })
  ; (Sachsen_Anhalt, { regional = "1FFBBBUUUUP"; country = "31FF0BBBUUUUP" })
  ; (Schleswig_Holstein, { regional = "FFBBBUUUUP"; country = "21FF0BBBUUUUP" })
  ; (Thueringen, { regional = "1FFBBBUUUUP"; country = "41FF0BBBUUUUP" })
  ]

(* Convert format pattern to regex *)
let pattern_to_regex pattern =
  let rec convert i groups =
    if i >= String.length pattern then (List.rev groups, "")
    else
      let ch = pattern.[i] in
      let rec count_same j =
        if j >= String.length pattern || pattern.[j] <> ch then j - i
        else count_same (j + 1)
      in
      let length = count_same i in
      convert (i + length) ((ch, length) :: groups)
  in
  let groups, _ = convert 0 [] in
  let regex_parts =
    List.map
      (fun (ch, len) ->
        match ch with
        | 'F' | 'B' | 'U' | 'P' ->
            "\\(" ^ String.concat "" (List.init len (fun _ -> "[0-9]")) ^ "\\)"
        | '0' -> String.make len '0'
        | _ -> String.make len ch)
      groups
  in
  Str.regexp ("^" ^ String.concat "" regex_parts ^ "$")

(* Extract groups from pattern match *)
let extract_groups pattern number =
  let rec extract i pos groups =
    if i >= String.length pattern then List.rev groups
    else
      let ch = pattern.[i] in
      let rec count_same j =
        if j >= String.length pattern || pattern.[j] <> ch then j - i
        else count_same (j + 1)
      in
      let length = count_same i in
      match ch with
      | 'F' | 'B' | 'U' | 'P' ->
          let group = String.sub number pos length in
          extract (i + length) (pos + length) (group :: groups)
      | _ -> extract (i + length) (pos + length) groups
  in
  extract 0 0 []

(* Replace pattern with values *)
let replace_pattern pattern f b u p =
  let values = [| f; b; u; p |] in
  let value_idx = ref 0 in
  let result = Buffer.create (String.length pattern) in
  let i = ref 0 in
  while !i < String.length pattern do
    let ch = pattern.[!i] in
    let rec count_same j =
      if j >= String.length pattern || pattern.[j] <> ch then j - !i
      else count_same (j + 1)
    in
    let length = count_same !i in
    (match ch with
    | 'F' | 'B' | 'U' | 'P' ->
        Buffer.add_string result values.(!value_idx);
        incr value_idx
    | _ -> Buffer.add_string result (String.make length ch));
    i := !i + length
  done;
  Buffer.contents result

let compact number = Utils.clean number "[ \\-./,]" |> String.trim

let validate ?region number =
  let number = compact number in
  if not (Utils.is_digits number) then raise Invalid_format;
  let len = String.length number in
  if len <> 10 && len <> 11 && len <> 13 then raise Invalid_length;

  let formats =
    match region with
    | Some r -> [ List.assoc r region_formats ]
    | None -> List.map snd region_formats
  in

  let is_valid =
    List.exists
      (fun fmt ->
        let regional_re = pattern_to_regex fmt.regional in
        let country_re = pattern_to_regex fmt.country in
        Str.string_match regional_re number 0
        || Str.string_match country_re number 0)
      formats
  in

  if not is_valid then raise Invalid_format;
  number

let is_valid ?region number =
  try
    ignore (validate ?region number);
    true
  with Invalid_format | Invalid_length | Invalid_component -> false

let guess_regions number =
  let number = compact number in
  List.filter_map
    (fun (region, fmt) ->
      let regional_re = pattern_to_regex fmt.regional in
      let country_re = pattern_to_regex fmt.country in
      if
        Str.string_match regional_re number 0
        || Str.string_match country_re number 0
      then Some region
      else None)
    region_formats

let to_regional_number number =
  let number = compact number in
  let rec try_convert = function
    | [] -> raise Invalid_format
    | (_, fmt) :: rest ->
        let country_re = pattern_to_regex fmt.country in
        if Str.string_match country_re number 0 then
          let groups = extract_groups fmt.country number in
          match groups with
          | [ f; b; u; p ] -> replace_pattern fmt.regional f b u p
          | _ -> try_convert rest
        else try_convert rest
  in
  try_convert region_formats

let to_country_number ?region number =
  let number = compact number in
  let formats =
    match region with
    | Some r -> [ (r, List.assoc r region_formats) ]
    | None -> region_formats
  in

  let matches =
    List.filter_map
      (fun (_, fmt) ->
        let regional_re = pattern_to_regex fmt.regional in
        if Str.string_match regional_re number 0 then
          let groups = extract_groups fmt.regional number in
          match groups with
          | [ f; b; u; p ] -> Some (replace_pattern fmt.country f b u p)
          | _ -> None
        else None)
      formats
  in

  match matches with
  | [] -> raise Invalid_format
  | [ result ] -> result
  | _ -> raise Invalid_component

let format ?region number =
  let number = compact number in
  let formats =
    match region with
    | Some r -> [ List.assoc r region_formats ]
    | None -> List.map snd region_formats
  in

  let rec try_format = function
    | [] -> number
    | fmt :: rest ->
        let regional_re = pattern_to_regex fmt.regional in
        if Str.string_match regional_re number 0 then
          let groups = extract_groups fmt.regional number in
          match groups with
          | [ f; b; u; p ] -> f ^ "/" ^ b ^ "/" ^ u ^ p
          | _ -> try_format rest
        else try_format rest
  in
  try_format formats
