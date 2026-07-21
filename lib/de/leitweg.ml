(** Leitweg-ID, a buyer reference or routing identifier for electronic invoices.

    For the successful transmission of an electronic invoice as invoicing party
    or sender, a unique identification and addressing of the invoice recipient
    is required. The Leitweg-ID must be transmitted as a mandatory requirement
    for electronic invoicing to public contracting authorities in the federal
    administration.

    More information:
    - https://leitweg-id.de/
    - https://de.wikipedia.org/wiki/Leitweg-ID
    - https://xeinkauf.de/app/uploads/2022/11/Leitweg-ID-Formatspezifikation-v2-0-2-1.pdf
*)

open Tools

exception Invalid_format
exception Invalid_length
exception Invalid_component
exception Invalid_checksum

let compact number = String.trim number |> String.uppercase_ascii

let is_valid_format number =
  let parts = String.split_on_char '-' number in
  let is_alnum_upper s =
    String.for_all (fun c -> (c >= '0' && c <= '9') || (c >= 'A' && c <= 'Z')) s
  in
  match parts with
  | [ p1; p2 ] ->
      let l1 = String.length p1 in
      let l2 = String.length p2 in
      l1 >= 2 && l1 <= 12 && Utils.is_digits p1 && l2 = 2 && Utils.is_digits p2
  | [ p1; p2; p3 ] ->
      let l1 = String.length p1 in
      let l2 = String.length p2 in
      let l3 = String.length p3 in
      l1 >= 2 && l1 <= 12 && Utils.is_digits p1 && l2 <= 30 && is_alnum_upper p2
      && l3 = 2 && Utils.is_digits p3
  | _ -> false

let validate number =
  let number = compact number in
  let len = String.length number in
  if len < 5 || len > 46 then raise Invalid_length;

  if not (is_valid_format number) then raise Invalid_format;

  let valid_states =
    [
      "01"
    ; "02"
    ; "03"
    ; "04"
    ; "05"
    ; "06"
    ; "07"
    ; "08"
    ; "09"
    ; "10"
    ; "11"
    ; "12"
    ; "13"
    ; "14"
    ; "15"
    ; "16"
    ; "99"
    ]
  in
  if not (List.mem (String.sub number 0 2) valid_states) then
    raise Invalid_component;

  let no_dash = Utils.clean number "-" in
  begin try ignore (Iso7064.Mod_97_10.validate no_dash) with
  | Iso7064.Mod_97_10.Invalid_checksum -> raise Invalid_checksum
  | Iso7064.Mod_97_10.Invalid_format -> raise Invalid_format
  end;

  number

let validate_result number =
  try Ok (validate number) with
  | Invalid_format -> Error Error.Invalid_format
  | Invalid_length -> Error Error.Invalid_length
  | Invalid_component -> Error Tools.Error.Invalid_component
  | Invalid_checksum -> Error Error.Invalid_checksum

let is_valid number = Result.is_ok (validate_result number)
