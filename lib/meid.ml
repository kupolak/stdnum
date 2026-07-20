(** MEID (Mobile Equipment Identifier).

    The Mobile Equipment Identifier is used to identify a physical piece of
    CDMA mobile station equipment.

    More information:
    - https://en.wikipedia.org/wiki/Mobile_Equipment_Identifier *)

open Tools

exception Invalid_format
exception Invalid_length
exception Invalid_component
exception Invalid_checksum

let hex_alphabet = "0123456789ABCDEF"

let compact number =
  Utils.clean number "[ -]" |> String.trim |> String.uppercase_ascii

let is_hex number =
  let rec check i =
    if i >= String.length number then true
    else if String.contains hex_alphabet number.[i] then check (i + 1)
    else false
  in
  check 0

let _parse number =
  let number = compact number in
  let len = String.length number in
  if len = 14 || len = 15 then begin
    if not (is_hex number) then raise Invalid_format;
    (String.sub number 0 14, if len = 15 then String.sub number 14 1 else "")
  end
  else if len = 18 || len = 19 then begin
    if not (Utils.is_digits number) then raise Invalid_format;
    (String.sub number 0 18, if len = 19 then String.sub number 18 1 else "")
  end
  else raise Invalid_length

let calc_check_digit number =
  if Utils.is_digits number then
    Luhn.calc_check_digit number
  else
    Luhn.calc_check_digit ~alphabet:hex_alphabet number

let compact_clean ?(strip_check_digit = true) number =
  let num_part, cd = _parse number in
  let cd = if strip_check_digit then "" else cd in
  let num_part, cd =
    if String.length num_part = 18 then
      let manufacturer = Int64.of_string (String.sub num_part 0 10) in
      let serial = Int64.of_string (String.sub num_part 10 8) in
      let hex_num = Printf.sprintf "%08LX%06LX" manufacturer serial in
      let new_cd = if cd <> "" then calc_check_digit hex_num else "" in
      (hex_num, new_cd)
    else (num_part, cd)
  in
  num_part ^ cd

let validate ?(strip_check_digit = true) number =
  let num_part, cd = _parse number in
  
  let num_part, cd =
    if String.length num_part = 18 then
      begin
        if cd <> "" then begin
          try ignore (Luhn.validate (num_part ^ cd))
          with Luhn.Invalid_checksum -> raise Invalid_checksum
             | Luhn.Invalid_format -> raise Invalid_format
        end;
        let manufacturer = Int64.of_string (String.sub num_part 0 10) in
        let serial = Int64.of_string (String.sub num_part 10 8) in
        if manufacturer > 0xFFFFFFFFL || serial > 0xFFFFFFL then
          raise Invalid_component;
        let hex_num = Printf.sprintf "%08LX%06LX" manufacturer serial in
        let new_cd = calc_check_digit hex_num in
        (hex_num, new_cd)
      end
    else if Utils.is_digits num_part then
      begin
        begin try
          ignore (Imei.validate (num_part ^ cd))
        with
        | Imei.Invalid_checksum -> raise Invalid_checksum
        | Imei.Invalid_format -> raise Invalid_format
        | Imei.Invalid_length -> raise Invalid_length
        end;
        (num_part, cd)
      end
    else
      begin
        if cd <> "" then begin
          try ignore (Luhn.validate ~alphabet:hex_alphabet (num_part ^ cd))
          with Luhn.Invalid_checksum -> raise Invalid_checksum
             | Luhn.Invalid_format -> raise Invalid_format
        end;
        (num_part, cd)
      end
  in
  let final_cd = if strip_check_digit then "" else cd in
  num_part ^ final_cd

let is_valid number =
  try
    ignore (validate number);
    true
  with Invalid_format | Invalid_length | Invalid_component | Invalid_checksum -> false

let format ?(separator = " ") ?(fmt = "") ?(add_check_digit = false) number =
  let num_part, cd = _parse number in
  
  let num_part, cd =
    if fmt = "dec" && String.length num_part = 14 then
      let manufacturer = Int64.of_string ("0x" ^ String.sub num_part 0 8) in
      let serial = Int64.of_string ("0x" ^ String.sub num_part 8 6) in
      let dec_num = Printf.sprintf "%010Ld%08Ld" manufacturer serial in
      let new_cd = if cd <> "" then calc_check_digit dec_num else "" in
      (dec_num, new_cd)
    else if fmt = "hex" && String.length num_part = 18 then
      let manufacturer = Int64.of_string (String.sub num_part 0 10) in
      let serial = Int64.of_string (String.sub num_part 10 8) in
      let hex_num = Printf.sprintf "%08LX%06LX" manufacturer serial in
      let new_cd = if cd <> "" then calc_check_digit hex_num else "" in
      (hex_num, new_cd)
    else (num_part, cd)
  in
  let cd = if add_check_digit && cd = "" then calc_check_digit num_part else cd in
  
  if String.length num_part = 14 then
    let parts = ref [] in
    for i = 0 to 6 do
      parts := String.sub num_part (i * 2) 2 :: !parts
    done;
    let parts = List.rev !parts in
    let parts = if cd <> "" then parts @ [cd] else parts in
    String.concat separator parts
  else
    let parts = [
      String.sub num_part 0 5;
      String.sub num_part 5 5;
      String.sub num_part 10 4;
      String.sub num_part 14 4;
    ] in
    let parts = if cd <> "" then parts @ [cd] else parts in
    String.concat separator parts
