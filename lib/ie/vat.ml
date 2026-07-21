(** VAT (Irish tax reference number).

    The Irish VAT number consists of 8 or 9 digits. The number is either 7
    digits and 1 letter (optionally followed by a W for married women), 7 digits
    and 2 letters, or 6 digits and 2 letters or symbols (in second and last
    position). *)

open Tools

exception Invalid_format
exception Invalid_length
exception Invalid_checksum

let compact number =
  let number =
    Utils.clean number "[ -]" |> String.trim |> String.uppercase_ascii
  in
  if String.starts_with ~prefix:"IE" number then
    String.sub number 2 (String.length number - 2)
  else number

let alphabet = "WABCDEFGHIJKLMNOPQRSTUV"
let get_alphabet_index c = try String.index alphabet c with Not_found -> 0

let calc_check_digit number =
  let number =
    let len = String.length number in
    if len < 7 then String.make (7 - len) '0' ^ number else number
  in
  let s = ref 0 in
  for i = 0 to 6 do
    s := !s + ((8 - i) * (int_of_char number.[i] - int_of_char '0'))
  done;
  let s =
    !s
    + (9 * if String.length number > 7 then get_alphabet_index number.[7] else 0)
  in
  String.make 1 alphabet.[s mod 23]

let validate number =
  let number = compact number in
  let len = String.length number in
  if len <> 8 && len <> 9 then raise Invalid_length;
  if
    (not (Utils.is_digits (String.sub number 0 1)))
    || not (Utils.is_digits (String.sub number 2 5))
  then raise Invalid_format;

  for i = 7 to len - 1 do
    if not (String.contains alphabet number.[i]) then raise Invalid_format
  done;

  if Utils.is_digits (String.sub number 0 7) then begin
    let check_input =
      String.sub number 0 7 ^ if len = 9 then String.sub number 8 1 else ""
    in
    if String.sub number 7 1 <> calc_check_digit check_input then
      raise Invalid_checksum
  end
  else begin
    let c = number.[1] in
    if String.contains "ABCDEFGHIJKLMNOPQRSTUVWXYZ+*" c then begin
      let check_input = String.sub number 2 5 ^ String.sub number 0 1 in
      if String.sub number 7 1 <> calc_check_digit check_input then
        raise Invalid_checksum
    end
    else raise Invalid_format
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

let convert number =
  let number = compact number in
  if String.length number = 8 && not (Utils.is_digits (String.sub number 1 1))
  then
    "0" ^ String.sub number 2 5 ^ String.sub number 0 1 ^ String.sub number 7 1
  else number
