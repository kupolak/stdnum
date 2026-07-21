(** IMO number (International Maritime Organization number).

    A number used to uniquely identify ships (the hull) for purposes of
    registering owners and management companies. The ship identification number
    consists of a six-digit sequentially assigned number and a check digit. The
    number is usually prefixed with "IMO".

    More information:
    - https://en.wikipedia.org/wiki/IMO_number *)

open Tools

exception Invalid_format
exception Invalid_length
exception Invalid_checksum

let compact number =
  let number =
    Utils.clean number "[ ]" |> String.uppercase_ascii |> String.trim
  in
  if String.length number >= 3 && String.sub number 0 3 = "IMO" then
    String.sub number 3 (String.length number - 3) |> String.trim
  else number

let calc_check_digit number =
  let sum = ref 0 in
  for i = 0 to min 5 (String.length number - 1) do
    let digit = int_of_char number.[i] - int_of_char '0' in
    sum := !sum + (digit * (7 - i))
  done;
  string_of_int (!sum mod 10)

let validate number =
  let number = compact number in

  if not (Utils.is_digits number) then raise Invalid_format;

  if String.length number <> 7 then raise Invalid_length;

  let number_part = String.sub number 0 6 in
  let check_digit = String.sub number 6 1 in
  if calc_check_digit number_part <> check_digit then raise Invalid_checksum;

  number

let is_valid number =
  try
    ignore (validate number);
    true
  with Invalid_format | Invalid_length | Invalid_checksum -> false

let format number = "IMO " ^ compact number
