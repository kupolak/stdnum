(** IDNO (Moldavian company identification number).

    The IDNO is used in Moldavia as unique identifier for legal entities. The
    number consists of 13 digits. The first digit identifies the registry,
    followed by three digits for the year the code was assigned. The number ends
    with five identifier digits and a check digit.

    More information:
    - https://www.idno.md *)

open Tools

exception Invalid_format
exception Invalid_length
exception Invalid_checksum

let compact number =
  Utils.clean number " " |> String.trim

let calc_check_digit number =
  let weights = [| 7; 3; 1; 7; 3; 1; 7; 3; 1; 7; 3; 1 |] in
  let check = ref 0 in
  for i = 0 to 11 do
    check := !check + (weights.(i) * (int_of_char number.[i] - int_of_char '0'))
  done;
  string_of_int (!check mod 10)

let validate number =
  let number = compact number in
  if not (Utils.is_digits number) then raise Invalid_format;
  if String.length number <> 13 then raise Invalid_length;
  if String.make 1 number.[12] <> calc_check_digit number then raise Invalid_checksum;
  number

let is_valid number =
  try
    ignore (validate number);
    true
  with Invalid_format | Invalid_length | Invalid_checksum -> false
