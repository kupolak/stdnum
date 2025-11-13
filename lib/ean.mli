(** EAN (International Article Number).

    Module for handling EAN (International Article Number) codes. This
    module handles numbers in EAN-13, EAN-8, UPC (12-digit) and GTIN (EAN-14) format.

    More information:
    - https://en.wikipedia.org/wiki/International_Article_Number *)

exception Invalid_format
(** Exception raised when the EAN has invalid format. *)

exception Invalid_length
(** Exception raised when the EAN has invalid length. *)

exception Invalid_checksum
(** Exception raised when the checksum validation fails. *)

val compact : string -> string
(** Convert the EAN to the minimal representation. This strips the number
    of any valid separators and removes surrounding whitespace.

    Example: [compact "978-0-471-11709-4"] returns ["9780471117094"] *)

val calc_check_digit : string -> string
(** Calculate the EAN check digit for the number. The number passed
    should not have the check digit included.

    Example: [calc_check_digit "978047111709"] returns ["4"] *)

val validate : string -> string
(** Check if the number is valid. This checks the length and checksum
    but does not check whether a known GS1 Prefix and company identifier
    are referenced. Returns the normalized number if valid.

    @raise Invalid_format if the number has invalid format
    @raise Invalid_length if the number has invalid length (must be 8, 12, 13, or 14 digits)
    @raise Invalid_checksum if the checksum validation fails *)

val is_valid : string -> bool
(** Check if the number is valid.
    Returns [true] if valid, [false] otherwise. *)
