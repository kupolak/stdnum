(** GRid (Global Release Identifier).

    The Global Release Identifier is used to identify releases of digital
    sound recordings and uses the ISO 7064 Mod 37, 36 algorithm to verify the
    correctness of the number.

    More information:
    - https://en.wikipedia.org/wiki/Global_Release_Identifier *)

open Tools

exception Invalid_length
exception Invalid_checksum
exception Invalid_format

let compact number =
  let number =
    Utils.clean number "[ -]" |> String.trim |> String.uppercase_ascii
  in
  (* Remove "GRID:" prefix if present *)
  if String.length number >= 5 && String.sub number 0 5 = "GRID:" then
    String.sub number 5 (String.length number - 5)
  else number

let validate number =
  let number = compact number in
  if String.length number <> 18 then raise Invalid_length;
  (* Use ISO 7064 Mod 37, 36 algorithm *)
  try Iso7064.Mod_37_36.validate number with
  | Iso7064.Mod_37_36.Invalid_checksum -> raise Invalid_checksum
  | Iso7064.Mod_37_36.Invalid_format -> raise Invalid_format

let is_valid number =
  try
    ignore (validate number);
    true
  with
  | Invalid_length | Invalid_checksum | Invalid_format -> false
  | Iso7064.Mod_37_36.Invalid_checksum | Iso7064.Mod_37_36.Invalid_format ->
      false

let format ?(separator = "-") number =
  let number = compact number in
  let parts =
    [
      String.sub number 0 2
    ; String.sub number 2 5
    ; String.sub number 7 10
    ; String.sub number 17 1
    ]
  in
  String.concat separator (List.filter (fun x -> x <> "") parts)
