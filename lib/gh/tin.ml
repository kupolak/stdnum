(** TIN (Taxpayer Identification Number, Ghana tax number).

    This number is issued by the Ghana Revenue Authority (GRA) to individuals
    who are not eligible for the Ghanacard PIN and other entities.

    This number consists of 11 alphanumeric characters. It begins with one of
    the following prefixes: P00 For Individuals. C00 For Companies limited by
    guarantee, shares, Unlimited (i.e organisation required to register with the
    RGD). G00 Government Agencies, MDAs. Q00 Foreign Missions, Employees of
    foreign missions. V00 Public Institutions, Trusts, Co-operatives, Foreign
    Shareholder (Offshore), (Entities not registered by RGD).

    More information:
    - https://www.oecd.org/tax/automatic-exchange/crs-implementation-and-assistance/tax-identification-numbers/Ghana-TIN.pdf
    - https://gra.gov.gh/tin/
    - https://gra.gov.gh/tin/tin-faq/ *)

open Tools

exception Invalid_format
exception Invalid_length
exception Invalid_checksum

let compact number = Utils.clean number " " |> String.uppercase_ascii

let calc_check_digit number =
  let sum = ref 0 in
  for i = 0 to 8 do
    let n = int_of_char number.[i + 1] - int_of_char '0' in
    sum := !sum + ((i + 1) * n)
  done;
  let check = !sum mod 11 in
  if check = 10 then "X" else string_of_int check

let validate number =
  let number = compact number in
  if String.length number <> 11 then raise Invalid_length;

  let re =
    Str.regexp
      "^[PCGQV]00[A-Z0-9][A-Z0-9][A-Z0-9][A-Z0-9][A-Z0-9][A-Z0-9][A-Z0-9][A-Z0-9]$"
  in
  if not (Str.string_match re number 0) then raise Invalid_format;

  if String.sub number 10 1 <> calc_check_digit number then
    raise Invalid_checksum;

  number

let is_valid number =
  try
    ignore (validate number);
    true
  with Invalid_format | Invalid_length | Invalid_checksum -> false
