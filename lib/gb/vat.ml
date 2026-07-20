(** VAT (United Kingdom (and Isle of Man) VAT registration number).

    The VAT number can either be a 9-digit standard number, a 12-digit standard
    number followed by a 3-digit branch identifier, a 5-digit number for
    government departments (first two digits are GD) or a 5-digit number for
    health authorities (first two digits are HA). The 9-digit variants use a
    weighted checksum.

    More information:
    - https://en.wikipedia.org/wiki/VAT_identification_number *)

open Tools

exception Invalid_format
exception Invalid_length
exception Invalid_component
exception Invalid_checksum

let compact number =
  let number = Utils.clean number "[ -.]" |> String.trim |> String.uppercase_ascii in
  if String.starts_with ~prefix:"GB" number || String.starts_with ~prefix:"XI" number then
    String.sub number 2 (String.length number - 2)
  else
    number

let checksum number =
  let weights = [| 8; 7; 6; 5; 4; 3; 2; 10; 1 |] in
  let sum = ref 0 in
  for i = 0 to 8 do
    let digit = int_of_char number.[i] - int_of_char '0' in
    sum := !sum + (digit * weights.(i))
  done;
  !sum mod 97

let validate number =
  let number = compact number in
  let len = String.length number in
  if len = 5 then begin
    if not (Utils.is_digits (String.sub number 2 3)) then raise Invalid_format;
    let n = int_of_string (String.sub number 2 3) in
    if String.starts_with ~prefix:"GD" number && n < 500 then ()
    else if String.starts_with ~prefix:"HA" number && n >= 500 then ()
    else raise Invalid_component
  end
  else if len = 11 && (String.starts_with ~prefix:"GD8888" number || String.starts_with ~prefix:"HA8888" number) then begin
    if not (Utils.is_digits (String.sub number 6 5)) then raise Invalid_format;
    let n = int_of_string (String.sub number 6 3) in
    if String.starts_with ~prefix:"GD" number && n < 500 then ()
    else if String.starts_with ~prefix:"HA" number && n >= 500 then ()
    else raise Invalid_component;
    let check = int_of_string (String.sub number 9 2) in
    if (n mod 97) <> check then raise Invalid_checksum
  end
  else if len = 9 || len = 12 then begin
    if not (Utils.is_digits number) then raise Invalid_format;
    let prefix3 = int_of_string (String.sub number 0 3) in
    let check_val = checksum (String.sub number 0 9) in
    if prefix3 >= 100 then begin
      if check_val <> 0 && check_val <> 42 && check_val <> 55 then raise Invalid_checksum
    end
    else begin
      if check_val <> 0 then raise Invalid_checksum
    end
  end
  else raise Invalid_length;
  number

let is_valid number =
  try
    ignore (validate number);
    true
  with Invalid_format | Invalid_length | Invalid_component | Invalid_checksum -> false

let format number =
  let number = compact number in
  let len = String.length number in
  if len = 5 then number
  else if len = 12 then
    String.sub number 0 3 ^ " " ^ String.sub number 3 4 ^ " " ^ String.sub number 7 2 ^ " " ^ String.sub number 9 3
  else
    String.sub number 0 3 ^ " " ^ String.sub number 3 4 ^ " " ^ String.sub number 7 2
