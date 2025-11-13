(** CAS RN (Chemical Abstracts Service Registry Number).

    The CAS Registry Number is a unique identifier assigned by the Chemical
    Abstracts Service (CAS) to a chemical substance.

    More information:
    - https://en.wikipedia.org/wiki/CAS_Registry_Number *)

exception Invalid_format
(** Exception raised when the CAS RN has invalid format. *)

exception Invalid_length
(** Exception raised when the CAS RN has invalid length. *)

exception Invalid_checksum
(** Exception raised when the checksum validation fails. *)

val compact : string -> string
(** Convert the number to the minimal representation. This adds hyphens
    if they are missing.

    Example: [compact "8786  5"] returns ["87-86-5"] *)

val calc_check_digit : string -> string
(** Calculate the check digit for the number. The passed number should not
    have the check digit included.

    Example: [calc_check_digit "87-86"] returns ["5"] *)

val validate : string -> string
(** Check if the number is valid. This checks the length, format and checksum.
    Returns the normalized number if valid.

    @raise Invalid_format if the number has invalid format
    @raise Invalid_length if the number has invalid length (not 7-12 chars)
    @raise Invalid_checksum if the checksum validation fails *)

val is_valid : string -> bool
(** Check if the number is valid.
    Returns [true] if valid, [false] otherwise. *)
