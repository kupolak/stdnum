(** Ust ID Nr. (Umsatzsteur Identifikationnummer, German VAT number).

    The number is 9 digits long and uses the ISO 7064 Mod 11, 10 check digit
    algorithm.

    More information:
    - https://ec.europa.eu/taxation_customs/vies/ *)

exception Invalid_format
exception Invalid_length
exception Invalid_checksum

val compact : string -> string
(** Convert the number to the minimal representation. This strips the
    number of any valid separators and removes surrounding whitespace. *)

val validate : string -> string
(** Check if the number provided is a valid VAT number. This checks the
    length, formatting and check digit.
    @raise Invalid_format if the number format is invalid
    @raise Invalid_length if the number is not 9 digits
    @raise Invalid_checksum if the checksum is invalid *)

val is_valid : string -> bool
(** Check if the number provided is a valid VAT number. *)
