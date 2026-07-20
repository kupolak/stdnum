(** Abgabenkontonummer (Austrian tax identification number).

    The Austrian tax identification number (Abgabenkontonummer) consists of 2
    digits for the issuing tax office (Finanzamtsnummer) and 7 digits for the
    subject and a check digit (Steuernummer).

    More information:
    - https://de.wikipedia.org/wiki/Abgabenkontonummer *)

exception Invalid_format
(** Exception raised when the TIN has invalid format. *)

exception Invalid_length
(** Exception raised when the TIN has invalid length. *)

exception Invalid_checksum
(** Exception raised when the checksum validation fails. *)

val compact : string -> string
(** Convert the number to the minimal representation. This strips the
    number of any valid separators and removes surrounding whitespace. *)

val calc_check_digit : string -> string
(** Calculate the check digit. *)

val validate : string -> string
(** Check if the number is a valid tax identification number. This checks
    the length, formatting and check digit.

    @raise Invalid_format if the number contains invalid characters
    @raise Invalid_length if the length is not 9
    @raise Invalid_checksum if the checksum fails *)

val is_valid : string -> bool
(** Check if the number is a valid tax identification number. *)

val format : string -> string
(** Reformat the number to the standard presentation format. *)
