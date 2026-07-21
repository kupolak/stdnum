(** VATIN (International value added tax identification number).

    The number VAT identification number (VATIN) is an identifier used in many
    countries. It starts with an ISO 3166-1 alpha-2 (2 letters) country code
    (except for Greece, which uses EL, instead of GR) and is followed by the
    country-specific identifier.

    This module supports all VAT numbers that are supported in python-stdnum.

    More information:
    - https://en.wikipedia.org/wiki/VAT_identification_number *)

exception Invalid_format
(** Exception raised when the number has invalid format. *)

exception Invalid_length
(** Exception raised when the number has invalid length. *)

exception Invalid_checksum
(** Exception raised when the checksum validation fails. *)

exception Invalid_component
(** Exception raised when a component of the number is invalid. *)

val compact : string -> string
(** Convert the number to the minimal representation. *)

val validate : string -> string
(** Check if the number is a valid VAT number. This performs the
    country-specific check for the number. *)

val is_valid : string -> bool
(** Check if the number is a valid VAT number. *)
