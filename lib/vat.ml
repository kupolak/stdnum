open Tools

exception Invalid_format
exception Invalid_length
exception Invalid_component

let compact number =
  (* Remove common separators and whitespace; keep letters/digits only. *)
  Utils.clean number "[ .,-/\t]" |> String.trim |> String.uppercase_ascii

let extract_cc_and_local number =
  let n = compact number in
  let len = String.length n in
  if len >= 2 then
    let cc = String.sub n 0 2 in
    let rest = String.sub n 2 (len - 2) in
    (cc, rest)
  else (n, "")

let is_alpha2 s =
  String.length s = 2
  && Char.code s.[0] >= Char.code 'A'
  && Char.code s.[0] <= Char.code 'Z'
  && Char.code s.[1] >= Char.code 'A'
  && Char.code s.[1] <= Char.code 'Z'

let map_greece_ni cc =
  (* Greece uses EL; ISO alpha-2 is GR. Northern Ireland uses XI; map to GB. *)
  if cc = "EL" then "GR" else if cc = "XI" then "GB" else cc

let validate number =
  let n = compact number in
  let cc, local = extract_cc_and_local n in
  if is_alpha2 cc then
    let cc = map_greece_ni cc in
    match cc with
    | "PL" -> (
        (* Poland VAT: NIP *)
        try "PL" ^ Pl.Nip.validate local with
        | Pl.Nip.Invalid_format -> raise Invalid_format
        | Pl.Nip.Invalid_length -> raise Invalid_length
        | Pl.Nip.Invalid_checksum -> raise Invalid_format)
    | "US" -> (
        (* US does not have VAT, but accept TIN forms when prefixed. *)
        try "US" ^ Us.Tin.validate local with _ -> raise Invalid_format)
    | _ -> raise Invalid_component
  else
    (* No or invalid country prefix: try known validators directly. *)
    let try_validators =
      [
        (fun () -> "PL" ^ Pl.Nip.validate n)
      ; (fun () -> "US" ^ Us.Tin.validate n)
      ]
    in
    let rec attempt = function
      | [] -> raise Invalid_format
      | f :: rest -> ( try f () with _ -> attempt rest)
    in
    attempt try_validators

let is_valid number =
  try
    ignore (validate number);
    true
  with _ -> false
