(** Asmens kodas (Lithuanian, personal numbers).

    The Asmens kodas consists of 11 digits. The first digits denotes the gender
    and birth century, the second through seventh denotes the birth date,
    followed by a three-digit serial and a check digit.

    More information:
    - https://lt.wikipedia.org/wiki/Asmens_kodas
    - https://en.wikipedia.org/wiki/National_identification_number#Lithuania *)

open Tools

exception Invalid_format
exception Invalid_length
exception Invalid_component
exception Invalid_checksum

let compact number =
  Utils.clean number " " |> String.trim

let validate ?(validate_birth_date=true) number =
  let number = compact number in
  if not (Utils.is_digits number) then raise Invalid_format;
  if String.length number <> 11 then raise Invalid_length;
  if validate_birth_date && number.[0] <> '9' then (
    try ignore (Ee.Ik.get_birth_date number)
    with Ee.Ik.Invalid_component -> raise Invalid_component
  );
  if String.make 1 number.[10] <> Ee.Ik.calc_check_digit number then
    raise Invalid_checksum;
  number

let is_valid ?(validate_birth_date=true) number =
  try
    ignore (validate ~validate_birth_date number);
    true
  with Invalid_format | Invalid_length | Invalid_component | Invalid_checksum -> false
