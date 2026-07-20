(** CVR (Momsregistreringsnummer, Danish VAT number).

    The CVR (Momsregistreringsnummer, VAT) is an 8 digit number with a
    straightforward check mechanism. *)

exception Invalid_format
(** Exception raised when the CVR has invalid format. *)

exception Invalid_length
(** Exception raised when the CVR has invalid length. *)

exception Invalid_checksum
(** Exception raised when the checksum validation fails. *)

val compact : string -> string
(** Convert the number to the minimal representation. This strips the
    number of any valid separators and removes surrounding whitespace. *)

val checksum : string -> int
(** Calculate the checksum. *)

val validate : string -> string
(** Check if the number provided is a valid VAT number. This checks the
    length, formatting and check digit.

    @raise Invalid_format if the number contains invalid characters
    @raise Invalid_length if the length is not 8
    @raise Invalid_checksum if the checksum fails *)

val is_valid : string -> bool
(** Check if the number provided is a valid VAT number. *)
