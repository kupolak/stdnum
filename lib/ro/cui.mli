(** Romanian CUI or CIF (Codul Unic de Înregistrare, Romanian company identifier).

    The CUI (Codul Unic de Înregistrare) is assigned to companies that are
    required to register with the Romanian Trade Register. The CIF (Codul de
    identificare fiscală) is identical but assigned to entities that have no such
    requirement. The names seem to be used interchangeably and some sources
    suggest that CIF is the new name for CUI.

    This number can change under some conditions. The number can be prefixed with
    RO to indicate that the entity has been registered for VAT.

    More information:
    - https://ro.wikipedia.org/wiki/Cod_de_identificare_fiscală
*)

exception Invalid_length
(** Exception raised when the number has an invalid length. *)

exception Invalid_format
(** Exception raised when the number has an invalid format. *)

exception Invalid_checksum
(** Exception raised when the checksum is invalid. *)

val compact : string -> string
(** Convert the number to the minimal representation. This strips the
    number of any valid separators and removes surrounding whitespace.
    The RO prefix is also removed if present.

    Example: [compact "185 472 90"] returns ["18547290"]
    Example: [compact "RO 185 472 90"] returns ["18547290"] *)

val calc_check_digit : string -> string
(** Calculate the check digit for a CUI/CIF number.
    The input should be the body of the number (without the check digit). *)

val validate : string -> string
(** Check if the number is a valid CUI or CIF number. This checks the length,
    formatting and check digit. Returns the normalized number if valid.

    @raise Invalid_format if the number has an invalid format
    @raise Invalid_length if the number has an invalid length
    @raise Invalid_checksum if the check digit is invalid *)

val is_valid : string -> bool
(** Check if the number is a valid CUI or CIF number.
    Returns [true] if valid, [false] otherwise. *)
