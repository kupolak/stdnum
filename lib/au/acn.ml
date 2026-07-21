(** ACN (Australian Company Number).

    The Australian Company Number (ACN) is a company identifier issued by the
    Australian Securities and Investments Commission.

    More information:
    - https://en.wikipedia.org/wiki/Australian_Company_Number *)

open Tools

exception Invalid_format
exception Invalid_length
exception Invalid_checksum

let compact number = Utils.clean number "[ ]" |> String.trim

let calc_check_digit number =
  let sum = ref 0 in
  for i = 0 to String.length number - 1 do
    let digit = int_of_char number.[i] - int_of_char '0' in
    sum := !sum + (digit * (i - 8))
  done;
  let check = !sum mod 10 in
  let check = if check < 0 then check + 10 else check in
  string_of_int check

let validate number =
  let number = compact number in
  if not (Utils.is_digits number) then raise Invalid_format;
  if String.length number <> 9 then raise Invalid_length;

  if calc_check_digit number <> String.sub number 8 1 then
    raise Invalid_checksum;

  number

let is_valid number =
  try
    ignore (validate number);
    true
  with Invalid_format | Invalid_length | Invalid_checksum -> false

let format number =
  let number = compact number in
  String.sub number 0 3 ^ " " ^ String.sub number 3 3 ^ " "
  ^ String.sub number 6 3

let to_abn number =
  let number = compact number in
  Abn.calc_check_digits number ^ number
