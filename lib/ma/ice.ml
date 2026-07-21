(** ICE (Identifiant Commun de l’Entreprise, التعريف الموحد للمقاولة, Morocco
    tax number).

    The ICE is a number that identifies the company and its branches in a unique
    and uniform way by all Moroccan administrations. It comes in addition to the
    other legal identifiers, notably the "identifiant fiscal" (IF), the "numéro
    de registre de commerce" (RC) and the CNSS number. The ICE does not replace
    these identifiers, which remain mandatory.

    The ICE is intended to ease communication among Moroccan administration
    branches, therefore simplifying procedures, increasing reliability and
    speed, and therefore reducing costs.

    The ICE applies to legal entities and their branches, as well as to natural
    persons.

    The ICE consists of 15 characters, where the first 9 represent the
    enterprise, the following 4 represent its establishments, and the last 2 are
    control characters.

    More information:
    - https://www.ice.gov.ma/
    - https://www.ice.gov.ma/ICE/Depliant_ICE.pdf
    - https://www.ice.gov.ma/ICE/Guide_ICE.pdf *)

open Tools

exception Invalid_format
exception Invalid_length
exception Invalid_checksum

let compact number = Utils.clean number " "

let validate number =
  let number = compact number in
  if String.length number <> 15 then raise Invalid_length;
  if not (Utils.is_digits number) then raise Invalid_format;
  if int_of_string number mod 97 <> 0 then raise Invalid_checksum;
  number

let is_valid number =
  try
    ignore (validate number);
    true
  with Invalid_format | Invalid_length | Invalid_checksum -> false

let format number =
  let number = compact number in
  let len = String.length number in
  if len < 15 then String.make (15 - len) '0' ^ number else number
