(** NACE (classification for businesses in the European Union).

    The NACE (nomenclature statistique des activités économiques dans la
    Communauté européenne) is a 4-level (and up to 4 digit) code for classifying
    economic activities. It is the European implementation of the UN
    classification ISIC.

    The first 4 digits are the same in all EU countries while additional levels
    and digits may be vary between countries. This module validates the numbers
    structure.

    More information:
    - https://en.wikipedia.org/wiki/Statistical_Classification_of_Economic_Activities_in_the_European_Community
*)

open Tools

exception Invalid_format
exception Invalid_length
exception Invalid_component

let compact number = Utils.clean number "[.]" |> String.trim

let validate number =
  let number = compact number in
  let len = String.length number in
  if len > 4 || len = 0 then raise Invalid_length;
  if len = 1 then begin
    if not (Utils.is_alpha number) then raise Invalid_format
  end
  else begin
    if not (Utils.is_digits number) then raise Invalid_format
  end;
  (* We omit numdb registry lookup for the OCaml port *)
  number

let is_valid number =
  try
    ignore (validate number);
    true
  with Invalid_format | Invalid_length | Invalid_component -> false

let format number =
  let number = compact number in
  if String.length number >= 2 then
    let part1 = String.sub number 0 2 in
    let part2 = String.sub number 2 (String.length number - 2) in
    if part2 = "" then part1 else part1 ^ "." ^ part2
  else number
