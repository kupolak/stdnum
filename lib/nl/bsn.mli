(** BSN (Burgerservicenummer, the Dutch citizen identification number).

    The BSN is a unique personal identifier and has been introduced as the
    successor to the sofinummer. It is issued to each Dutch national. The number
    consists of up to nine digits (the leading zeros are commonly omitted) and
    contains a simple checksum.

    More information:
    - https://en.wikipedia.org/wiki/National_identification_number#Netherlands
    - https://nl.wikipedia.org/wiki/Burgerservicenummer
    - https://www.burgerservicenummer.nl/ *)

exception Invalid_format
exception Invalid_length
exception Invalid_checksum

val compact : string -> string
(** Remove any formatting characters from the number, pad with leading zeros
    to 9 digits, and return a clean string. *)

val checksum : string -> int
(** Calculate the checksum over the number. A valid number should have
    a checksum of 0. *)

val validate : string -> string
(** Check if the number is a valid BSN. This checks the length and whether
    the check digit is correct.
    @raise Invalid_format if the number contains non-digit characters or is zero
    @raise Invalid_length if the number is not 9 digits
    @raise Invalid_checksum if the checksum is invalid *)

val is_valid : string -> bool
(** Check if the number is a valid BSN. *)

val format : string -> string
(** Reformat the passed number to the standard presentation format (XXXX.XX.XXX). *)
