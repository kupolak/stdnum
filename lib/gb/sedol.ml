(** SEDOL number (Stock Exchange Daily Official List number).

    The SEDOL number is a security identifier used in the United Kingdom and
    Ireland assigned by the London Stock Exchange. A SEDOL is seven characters
    in length consisting of six alphanumeric digits, followed by a check digit.

    More information:
    - https://en.wikipedia.org/wiki/SEDOL *)

open Tools

exception Invalid_format
exception Invalid_length
exception Invalid_checksum

let alphabet = "0123456789 BCD FGH JKLMN PQRST VWXYZ"

let compact number =
  Utils.clean number "[ ]" |> String.trim |> String.uppercase_ascii

let index_of char =
  let rec aux i =
    if i >= String.length alphabet then raise Not_found
    else if alphabet.[i] = char then i
    else aux (i + 1)
  in
  aux 0

let calc_check_digit number =
  let weights = [| 1; 3; 1; 7; 3; 9 |] in
  let sum = ref 0 in
  for i = 0 to 5 do
    try sum := !sum + (weights.(i) * index_of number.[i])
    with Not_found -> raise Invalid_format
  done;
  string_of_int ((10 - (!sum mod 10)) mod 10)

let validate number =
  let number = compact number in
  let check_chars s =
    let rec aux i =
      if i >= String.length s then true
      else if not (String.contains alphabet s.[i]) then false
      else aux (i + 1)
    in
    aux 0
  in
  if not (check_chars number) then raise Invalid_format;
  if String.length number <> 7 then raise Invalid_length;

  let is_digit c = c >= '0' && c <= '9' in
  if is_digit number.[0] && not (Utils.is_digits number) then
    raise Invalid_format;

  if calc_check_digit (String.sub number 0 6) <> String.sub number 6 1 then
    raise Invalid_checksum;
  number

let validate_result number =
  try Ok (validate number) with
  | Invalid_format -> Error Error.Invalid_format
  | Invalid_length -> Error Error.Invalid_length
  | Invalid_checksum -> Error Error.Invalid_checksum

let is_valid number =
  try
    ignore (validate number);
    true
  with Invalid_format | Invalid_length | Invalid_checksum -> false

let to_isin number = Isin_core.from_natid "GB" number
