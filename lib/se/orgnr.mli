(** Swedish Orgnr (Organisationsnummer, company number).

    The Orgnr (Organisationsnummer) is the national number to identify Swedish
    companies and consists of 10 digits. These are the first 10 digits in the
    Swedish VAT number (without 'SE' prefix and '01' suffix).

    The number uses the Luhn checksum algorithm for validation.
*)

exception Invalid_length
(** Exception raised when the number has an invalid length (not 10 digits). *)

exception Invalid_format
(** Exception raised when the number contains non-digit characters. *)

exception Invalid_checksum
(** Exception raised when the Luhn checksum is invalid. *)

val compact : string -> string
(** Convert the number to the minimal representation. This strips spaces,
    dashes, and periods, and removes surrounding whitespace.

    Example: [compact "123456-7897"] returns ["1234567897"] *)

val luhn_checksum : string -> int
(** Calculate the Luhn checksum for the number. Returns the checksum modulo 10.
    A valid number should have a checksum of 0. *)

val validate : string -> string
(** Check if the number is a valid organisation number. This checks the length,
    formatting, and Luhn check digit. Returns the normalized number if valid.

    @raise Invalid_format if the number contains non-digit characters
    @raise Invalid_length if the number is not 10 digits
    @raise Invalid_checksum if the Luhn checksum is invalid *)

val is_valid : string -> bool
(** Check if the number is a valid organisation number.
    Returns [true] if valid, [false] otherwise. *)

val format : string -> string
(** Reformat the number to the standard presentation format (XXXXXX-XXXX).

    Example: [format "1234567897"] returns ["123456-7897"] *)
