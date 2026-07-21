(** PPS No (Personal Public Service Number, Irish personal number).

    The Personal Public Service number consists of 7 digits, and one or two
    letters. The first letter is a check character. When present (which should
    be the case for new numbers as of 2013), the second letter can be 'A' (for
    individuals) or 'H' (for non-individuals, such as limited companies, trusts,
    partnerships and unincorporated bodies). As of 2024, B was accepted as a
    second letter on all new PPS numbers.

    Pre-2013 values may have 'W', 'T', or 'X' as the second letter ; it is
    ignored by the check. *)

open Tools

exception Invalid_format
exception Invalid_length
exception Invalid_checksum

let compact number =
  Utils.clean number "[ -]" |> String.trim |> String.uppercase_ascii

let pps_re = Str.regexp "^[0-9][0-9][0-9][0-9][0-9][0-9][0-9][A-W][ABHWTX]?$"

let validate number =
  let number = compact number in
  if not (Str.string_match pps_re number 0) then raise Invalid_format;
  if String.length number <> 8 && String.length number <> 9 then
    raise Invalid_length;
  if String.length number = 9 && String.contains "ABH" number.[8] then begin
    if
      String.sub number 7 1
      <> Vat.calc_check_digit (String.sub number 0 7 ^ String.sub number 8 1)
    then raise Invalid_checksum
  end
  else begin
    if String.sub number 7 1 <> Vat.calc_check_digit (String.sub number 0 7)
    then raise Invalid_checksum
  end;
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
