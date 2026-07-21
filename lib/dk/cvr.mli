(** CVR (Momsregistreringsnummer, Danish VAT number).

    The CVR (Momsregistreringsnummer, VAT) is an 8 digit number with a
    straightforward check mechanism. *)

exception Invalid_format
exception Invalid_length
exception Invalid_checksum

val compact : string -> string
(** Convert the number to the minimal representation. This strips the number of
    any valid separators and removes surrounding whitespace. *)

val checksum : string -> int
(** Calculate the checksum. *)

val validate : string -> string
(** Check if the number provided is a valid VAT number. This checks the length,
    formatting and check digit.

    @raise Invalid_checksum if the checksum fails *)

val validate_result : string -> (string, Tools.Error.t) result
(** Same as {!validate} but returns a [result] instead of raising exceptions. *)

val is_valid : string -> bool
(** Check if the number provided is a valid VAT number. *)
