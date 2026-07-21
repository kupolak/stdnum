(** NIF, sometimes N.I.F. (Numéro d'Identification Fiscale, Algeria tax number).

    The NIF was adopted by the Algerian tax authorities on 2006, replacing the
    NIS number.

    The NIF applies to physical persons, legal persons, legal entities,
    administrative entities, local branches for foreign companies, associations,
    professional organisations, etc.

    The NIF consists of 15 digits, but sometimes it can be 20 digits long in
    order to represent branches or secondary establishments.

    More information:
    - http://www.jecreemonentreprise.dz/index.php?option=com_content&view=article&id=612&Itemid=463&lang=fr
    - https://www.mf.gov.dz/index.php/fr/fiscalite
    - https://cnrcinfo.cnrc.dz/numero-didentification-fiscale-nif/
    - https://nifenligne.mfdgi.gov.dz/
    - http://nif.mfdgi.gov.dz/nif.asp *)

open Tools

exception Invalid_format
exception Invalid_length

let compact number = Utils.clean number " "

let validate number =
  let number = compact number in
  let len = String.length number in
  if len <> 15 && len <> 20 then raise Invalid_length;
  if not (Utils.is_digits number) then raise Invalid_format;
  number

let is_valid number =
  try
    ignore (validate number);
    true
  with Invalid_format | Invalid_length -> false

let format number = compact number
