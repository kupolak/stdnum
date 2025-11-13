(** Orgnr (Organisasjonsnummer, Norwegian organisation number).

    The Organisasjonsnummer is a 9-digit number with a straightforward check
    mechanism. *)

exception Invalid_format
exception Invalid_length
exception Invalid_checksum

val compact : string -> string
(** Convert the number to the minimal representation. This strips the
    number of any valid separators and removes surrounding whitespace. *)

val checksum : string -> int
(** Calculate the checksum for the number. *)

val validate : string -> string
(** Check if the number is a valid organisation number. This checks the
    length, formatting and check digit.
    Raises Invalid_format, Invalid_length, or Invalid_checksum if invalid. *)

val is_valid : string -> bool
(** Check if the number is a valid organisation number. *)

val format : string -> string
(** Reformat the number to the standard presentation format (XXX XXX XXX). *)
