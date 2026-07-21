(** ОГРН, OGRN, PSRN, ОГРНИП, OGRNIP (Russian Primary State Registration
    Number).

    The ОГРН (Основной государственный регистрационный номер, Primary State
    Registration Number) is a Russian identifier for legal entities. The number
    consists of 13 or 15 digits and includes information on the type of
    organisation, the registration year and a tax inspection code. The 15 digit
    variant is called ОГРНИП (Основной государственный регистрационный номер
    индивидуального предпринимателя, Primary State Registration Number of an
    Individual Entrepreneur).

    More information:
    - https://ru.wikipedia.org/wiki/Основной_государственный_регистрационный_номер
    - https://ru.wikipedia.org/wiki/Основной_государственный_регистрационный_номер_индивидуального_предпринимателя
*)

open Tools

exception Invalid_format
exception Invalid_length
exception Invalid_checksum
exception Invalid_component

let compact number = Utils.clean number " "

let calc_check_digit number =
  let base = String.sub number 0 (String.length number - 1) in
  let mod_n s n =
    let rec loop acc i =
      if i = String.length s then acc
      else
        let digit = int_of_char s.[i] - int_of_char '0' in
        loop (((acc * 10) + digit) mod n) (i + 1)
    in
    loop 0 0
  in
  if String.length number = 13 then string_of_int (mod_n base 11 mod 10)
  else string_of_int (mod_n base 13)

let validate number =
  let number = compact number in
  if not (Utils.is_digits number) then raise Invalid_format;
  let len = String.length number in
  if len = 13 then begin
    if number.[0] = '0' then raise Invalid_component
  end
  else if len = 15 then begin
    if number.[0] <> '3' && number.[0] <> '4' then raise Invalid_component
  end
  else raise Invalid_length;
  let check = String.sub number (len - 1) 1 in
  let calc_check = calc_check_digit number in
  if check <> calc_check then raise Invalid_checksum;
  number

let validate_result number =
  try Ok (validate number) with
  | Invalid_format -> Error Error.Invalid_format
  | Invalid_length -> Error Error.Invalid_length
  | Invalid_checksum -> Error Error.Invalid_checksum
  | Invalid_component -> Error Tools.Error.Invalid_component

let is_valid number = Result.is_ok (validate_result number)
