(** Registrikood (Estonian organisation registration code).

    All organisations are assigned a unique tax identification code from the
    commercial register, from the state register or from the non-profit
    associations and foundations register. The code consists of 8 digits.

    Commercial company numbers start with a 1, schools and government numbers
    with a 7, non-profit organisations with an 8 and foundations with a 9. The
    number uses the same check digit algorithm as the Isikukood although that
    fact is undocumented.

    More information:
    - https://ariregister.rik.ee/
    - https://mtr.mkm.ee/ *)

open Tools

exception Invalid_format
exception Invalid_length
exception Invalid_component
exception Invalid_checksum

let compact number =
  Utils.clean number " " |> String.trim

let validate number =
  let number = compact number in
  if not (Utils.is_digits number) then raise Invalid_format;
  if String.length number <> 8 then raise Invalid_length;
  
  let first_char = number.[0] in
  if first_char <> '1' && first_char <> '7' && first_char <> '8' && first_char <> '9' then
    raise Invalid_component;
    
  let check_digit = Ik.calc_check_digit number in
  if String.sub number 7 1 <> check_digit then raise Invalid_checksum;
  
  number

let is_valid number =
  try
    ignore (validate number);
    true
  with Invalid_format | Invalid_length | Invalid_component | Invalid_checksum -> false
