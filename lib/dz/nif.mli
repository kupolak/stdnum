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

exception Invalid_format
(** Exception raised when the NIF has invalid format. *)

exception Invalid_length
(** Exception raised when the NIF has invalid length. *)

val compact : string -> string
(** Convert the number to the minimal representation. This strips the number of
    any valid separators and removes surrounding whitespace. *)

val validate : string -> string
(** Check if the number is a valid Algeria NIF number. This checks the length
    and formatting.

    @raise Invalid_format if the number contains invalid characters
    @raise Invalid_length if the length is not 15 or 20 *)

val is_valid : string -> bool
(** Check if the number is a valid Algeria NIF number. *)

val format : string -> string
(** Reformat the number to the standard presentation format. *)
