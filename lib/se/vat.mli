(** Swedish VAT (Moms, Mervärdesskatt, VAT number).

    The Momsregistreringsnummer is used for VAT (Moms, Mervärdesskatt) purposes
    and consists of 12 digits. The last two digits must be "01". The first 10
    digits are a valid Organisationsnummer with Luhn checksum.
*)

exception Invalid_format
(** Exception raised when the VAT number has invalid format (non-digits or
    last two digits are not "01"). *)

exception Invalid_checksum
(** Exception raised when the Luhn checksum of the first 10 digits is invalid.
    This exception is re-exported from the Orgnr module. *)

val compact : string -> string
(** Convert the number to the minimal representation. This strips spaces,
    dashes, and periods, removes the "SE" prefix if present, and removes
    surrounding whitespace.

    Example: [compact "SE 123456789701"] returns ["123456789701"] *)

val validate : string -> string
(** Check if the number is a valid VAT number. This checks the length,
    formatting, and validates the first 10 digits using Orgnr validation
    (Luhn checksum). Returns the normalized number if valid.

    @raise Invalid_format if the number contains non-digit characters or if
           the last two digits are not "01"
    @raise Orgnr.Invalid_length if the number is not 12 digits
    @raise Orgnr.Invalid_checksum if the Luhn checksum of the first 10 digits
           is invalid *)

val is_valid : string -> bool
(** Check if the number is a valid VAT number.
    Returns [true] if valid, [false] otherwise. *)
