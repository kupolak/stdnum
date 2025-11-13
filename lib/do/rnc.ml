(** RNC (Registro Nacional del Contribuyente, Dominican Republic tax number).

    The RNC is the Dominican Republic taxpayer registration number for
    institutions. The number consists of 9 digits.

    More information:
    - https://dgii.gov.do/ *)

open Tools

exception Invalid_format
exception Invalid_length
exception Invalid_checksum

(* List of RNCs that do not match the checksum but are nonetheless valid *)
let whitelist =
  [
    "101581601"
  ; "101582245"
  ; "101595422"
  ; "101595785"
  ; "10233317"
  ; "131188691"
  ; "401007374"
  ; "501341601"
  ; "501378067"
  ; "501620371"
  ; "501651319"
  ; "501651823"
  ; "501651845"
  ; "501651926"
  ; "501656006"
  ; "501658167"
  ; "501670785"
  ; "501676936"
  ; "501680158"
  ; "504654542"
  ; "504680029"
  ; "504681442"
  ; "505038691"
  ]

let compact number = Utils.clean number "[ \\-]" |> String.trim

let calc_check_digit number =
  let weights = [ 7; 9; 8; 6; 5; 4; 3; 2 ] in
  let number_list =
    List.map (fun x -> int_of_char x - 48) (List.of_seq (String.to_seq number))
  in
  let check =
    List.fold_left2 (fun acc w n -> acc + (w * n)) 0 weights number_list
  in
  let check = check mod 11 in
  string_of_int (((10 - check) mod 9) + 1)

let validate number =
  let number = compact number in
  if not (Utils.is_digits number) then raise Invalid_format;
  if List.mem number whitelist then number
  else (
    if String.length number <> 9 then raise Invalid_length;
    if String.make 1 number.[8] <> calc_check_digit (String.sub number 0 8) then
      raise Invalid_checksum;
    number)

let is_valid number =
  try
    ignore (validate number);
    true
  with Invalid_format | Invalid_length | Invalid_checksum -> false

let format number =
  let number = compact number in
  if String.length number <> 9 then number
  else
    String.sub number 0 1 ^ "-" ^ String.sub number 1 2 ^ "-"
    ^ String.sub number 3 5 ^ "-" ^ String.sub number 8 1
