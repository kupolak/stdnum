(** Romanian CF (Cod de înregistrare în scopuri de TVA, Romanian VAT number).

    The Romanian CF is used for VAT purposes and can be either a CUI/CIF (2-10
    digits) or a CNP (13 digits). The number may be prefixed with "RO" to
    indicate VAT registration.

    This module acts as a wrapper around the CUI and CNP validators, accepting
    both formats.

    More information:
    - https://ro.wikipedia.org/wiki/Cod_de_identificare_fiscală *)

exception Invalid_length
exception Invalid_format
exception Invalid_component
exception Invalid_checksum

val compact : string -> string
(** Convert the number to the minimal representation. This strips the number of
    any valid separators and removes surrounding whitespace.

    Example: [compact "RO 185 472 90"] returns ["RO18547290"] Example:
    [compact "185 472 90"] returns ["18547290"] *)

val calc_check_digit : string -> string
(** Calculate the check digit for CUI/CIF numbers. This is provided for
    backwards compatibility with the CUI module. *)

val validate : string -> string
(** Check if the number is a valid VAT number. This accepts both CUI/CIF numbers
    (2-10 digits, optionally prefixed with "RO") and CNP numbers (13 digits).
    Returns the normalized number if valid.

    @raise Invalid_checksum if the check digit is invalid *)

val validate_result : string -> (string, Tools.Error.t) result
(** Same as {!validate} but returns a [result] instead of raising exceptions. *)

val is_valid : string -> bool
(** Check if the number is a valid VAT number. Returns [true] if valid, [false]
    otherwise. *)
