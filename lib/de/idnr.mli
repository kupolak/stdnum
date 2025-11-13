(** IdNr (Steuerliche Identifikationsnummer, German personal tax number).

    The IdNr (or Steuer-IdNr) is a personal identification number that is
    assigned to individuals in Germany for tax purposes and is meant to replace
    the Steuernummer. The number consists of 11 digits and does not embed any
    personal information.

    More information:
    - https://de.wikipedia.org/wiki/Steuerliche_Identifikationsnummer
    - http://www.identifikationsmerkmal.de/ *)

exception Invalid_format
exception Invalid_length
exception Invalid_checksum

val compact : string -> string
(** Convert the number to the minimal representation. This strips the
    number of any valid separators and removes surrounding whitespace. *)

val validate : string -> string
(** Check if the number provided is a valid tax identification number.
    This checks the length, formatting and check digit.
    @raise Invalid_format if the number format is invalid
    @raise Invalid_length if the number is not 11 digits
    @raise Invalid_checksum if the checksum is invalid *)

val is_valid : string -> bool
(** Check if the number provided is a valid tax identification number. *)

val format : string -> string
(** Reformat the number to the standard presentation format (XX XXX XXX XXX). *)
