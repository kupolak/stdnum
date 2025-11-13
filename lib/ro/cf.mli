(** Romanian CF (Cod de înregistrare în scopuri de TVA, Romanian VAT number).

    The Romanian CF is used for VAT purposes and can be either a CUI/CIF
    (2-10 digits) or a CNP (13 digits). The number may be prefixed with "RO"
    to indicate VAT registration.

    This module acts as a wrapper around the CUI and CNP validators,
    accepting both formats.

    More information:
    - https://ro.wikipedia.org/wiki/Cod_de_identificare_fiscală
*)

exception Invalid_length
(** Exception raised when the number has an invalid length. *)

exception Invalid_format
(** Exception raised when the number has an invalid format. *)

exception Invalid_component
(** Exception raised when a component is invalid (for CNP validation). *)

exception Invalid_checksum
(** Exception raised when the checksum is invalid. *)

val compact : string -> string
(** Convert the number to the minimal representation. This strips the
    number of any valid separators and removes surrounding whitespace.

    Example: [compact "RO 185 472 90"] returns ["RO18547290"]
    Example: [compact "185 472 90"] returns ["18547290"] *)

val calc_check_digit : string -> string
(** Calculate the check digit for CUI/CIF numbers.
    This is provided for backwards compatibility with the CUI module. *)

val validate : string -> string
(** Check if the number is a valid VAT number. This accepts both CUI/CIF
    numbers (2-10 digits, optionally prefixed with "RO") and CNP numbers
    (13 digits). Returns the normalized number if valid.

    @raise Invalid_format if the number has an invalid format
    @raise Invalid_length if the number has an invalid length
    @raise Invalid_component if a component is invalid (CNP only)
    @raise Invalid_checksum if the check digit is invalid *)

val is_valid : string -> bool
(** Check if the number is a valid VAT number.
    Returns [true] if valid, [false] otherwise. *)
