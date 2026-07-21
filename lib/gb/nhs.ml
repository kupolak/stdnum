(** NHS (United Kingdom National Health Service patient identifier).

    The NHS number is used by the NHS (National Health Service) and its partners
    to uniquely identify patients. The number is used in England, Wales and the
    Isle of Man. The number is assigned at birth and consists of 10 digits where
    the final digit is a check digit.

    More information:
    - https://en.wikipedia.org/wiki/NHS_number *)

open Tools

exception Invalid_format
exception Invalid_length
exception Invalid_checksum

let compact number = Utils.clean number "[ -]" |> String.trim

let checksum number =
  let sum = ref 0 in
  let len = String.length number in
  for i = 0 to len - 1 do
    let digit = int_of_char number.[i] - int_of_char '0' in
    sum := !sum + (digit * (len - i))
  done;
  !sum mod 11

let validate number =
  let number = compact number in
  if not (Utils.is_digits number) then raise Invalid_format;
  if String.length number <> 10 then raise Invalid_length;
  if checksum number <> 0 then raise Invalid_checksum;
  number

let is_valid number =
  try
    ignore (validate number);
    true
  with Invalid_format | Invalid_length | Invalid_checksum -> false

let format ?(separator = " ") number =
  let number = compact number in
  String.sub number 0 3 ^ separator ^ String.sub number 3 3 ^ separator
  ^ String.sub number 6 4
