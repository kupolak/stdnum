(** Wertpapierkennnummer (German securities identification code).

    The WKN, WPKN, WPK (Wertpapierkennnummer) is a German code to identify
    securities. It is a 6-digit alphanumeric number without a check digit that no
    longer has any structure. It is expected to be replaced by the ISIN.

    More information:
    - https://en.wikipedia.org/wiki/Wertpapierkennnummer *)

open Tools

exception Invalid_format
exception Invalid_length

let compact number =
  Utils.clean number "[ ]" |> String.trim |> String.uppercase_ascii

(* O and I are not valid but are accounted for in the check digit calculation *)
let alphabet = "0123456789ABCDEFGH JKLMN PQRSTUVWXYZ"

let validate number =
  let number = compact number in
  (* Check if all characters are in the alphabet *)
  let is_valid_char c = String.contains alphabet c in
  if not (String.for_all is_valid_char number) then raise Invalid_format;
  if String.length number <> 6 then raise Invalid_length;
  number

let is_valid number =
  try
    ignore (validate number);
    true
  with Invalid_format | Invalid_length -> false

let to_isin number =
  let number = validate number in
  (* Convert to ISIN: DE + 000 + WKN + check digit *)
  let base = "DE000" ^ number in
  (* Calculate ISIN check digit using Luhn mod 10 *)
  let to_digits s =
    let result = ref [] in
    String.iter
      (fun c ->
        if c >= '0' && c <= '9' then
          result := (int_of_char c - int_of_char '0') :: !result
        else if c >= 'A' && c <= 'Z' then
          let value = int_of_char c - int_of_char 'A' + 10 in
          result := (value mod 10) :: (value / 10) :: !result)
      s;
    List.rev !result
  in
  let digits = to_digits base in
  (* Luhn algorithm: double every second digit from right starting with second-to-last *)
  let len = List.length digits in
  let rec luhn_sum idx ds sum =
    match ds with
    | [] -> sum
    | d :: rest ->
        let pos_from_right = len - idx - 1 in
        let should_double = pos_from_right mod 2 = 0 in
        (* Even positions from right *)
        let value = if should_double then d * 2 else d in
        let value = if value > 9 then value - 9 else value in
        luhn_sum (idx + 1) rest (sum + value)
  in
  let sum = luhn_sum 0 digits 0 in
  let check_digit = (10 - (sum mod 10)) mod 10 in
  base ^ string_of_int check_digit
