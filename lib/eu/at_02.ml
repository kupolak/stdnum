(** SEPA Identifier of the Creditor (AT-02).

    This identifier is indicated in the ISO 20022 data element `Creditor Scheme
    Identification`. The creditor can be a legal entity, or an association that
    is not a legal entity, or a person.

    The first two digits contain the ISO country code, the next two are check
    digits for the ISO 7064 Mod 97, 10 checksum, the next tree contain the
    Creditor Business Code (or `ZZZ` if no business code used) and the remainder
    contains the country-specific identifier. *)

open Tools

exception Invalid_format
exception Invalid_checksum

let compact number =
  Utils.clean number "[- /?:().m'+\"]" |> String.trim |> String.uppercase_ascii

let get_test_string number =
  let len = String.length number in
  if len < 7 then raise Invalid_format;
  let part1 = String.sub number 7 (len - 7) in
  let part2 = String.sub number 0 4 in
  part1 ^ part2

let validate number =
  let number = compact number in
  let test_number =
    try get_test_string number with Invalid_format -> raise Invalid_format
  in
  begin try ignore (Iso7064.Mod_97_10.validate test_number) with
  | Iso7064.Mod_97_10.Invalid_checksum -> raise Invalid_checksum
  | Iso7064.Mod_97_10.Invalid_format -> raise Invalid_format
  end;
  number

let validate_result number =
  try Ok (validate number) with
  | Invalid_format -> Error Error.Invalid_format
  | Invalid_checksum -> Error Error.Invalid_checksum

let is_valid number =
  try
    ignore (validate number);
    true
  with Invalid_format | Invalid_checksum -> false

let calc_check_digits number =
  let number = compact number in
  let len = String.length number in
  if len < 7 then raise Invalid_format;
  let number_zero =
    String.sub number 0 2 ^ "00" ^ String.sub number 4 (len - 4)
  in
  let test_string = get_test_string number_zero in
  let test_string_no_zero =
    String.sub test_string 0 (String.length test_string - 2)
  in
  Iso7064.Mod_97_10.calc_check_digits test_string_no_zero
