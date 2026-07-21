(** VATIN (International value added tax identification number).

    The number VAT identification number (VATIN) is an identifier used in many
    countries. It starts with an ISO 3166-1 alpha-2 (2 letters) country code
    (except for Greece, which uses EL, instead of GR) and is followed by the
    country-specific identifier.

    This module supports all VAT numbers that are supported in python-stdnum.

    More information:
    - https://en.wikipedia.org/wiki/VAT_identification_number *)

exception Invalid_format
exception Invalid_length
exception Invalid_checksum
exception Invalid_component

val compact : string -> string
(** Convert the number to the minimal representation. *)

val validate : string -> string
(** Check if the number is a valid VAT number. This performs the
    country-specific check for the number. *)

val validate_result : string -> (string, Tools.Error.t) result
(** Same as {!validate} but returns a [result] instead of raising exceptions. *)

val is_valid : string -> bool
(** Check if the number is a valid VAT number. *)
