(** Onderwijsnummer (the Dutch student identification number).

    The onderwijsnummers (education number) is very similar to the BSN (Dutch
    citizen identification number), but is for students without a BSN. It uses a
    checksum mechanism similar to the BSN.

    More information:
    - https://nl.wikipedia.org/wiki/Onderwijsnummer *)

exception Invalid_format
exception Invalid_length
exception Invalid_checksum

val compact : string -> string
(** Remove any formatting characters from the number, pad with leading zeros
    to 9 digits, and return a clean string. (Uses BSN's compact function) *)

val checksum : string -> int
(** Calculate the checksum over the number. A valid onderwijsnummer should have
    a checksum of 5. (Uses BSN's checksum function) *)

val validate : string -> string
(** Check if the number is a valid onderwijsnummer. This checks the length,
    whether it starts with "10", and whether the check digit gives checksum 5.
    @raise Invalid_format if the number contains non-digit characters, is zero, or doesn't start with "10"
    @raise Invalid_length if the number is not 9 digits
    @raise Invalid_checksum if the checksum is not 5 *)

val is_valid : string -> bool
(** Check if the number is a valid onderwijsnummer. *)
