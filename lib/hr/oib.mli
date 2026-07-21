(** OIB (Osobni identifikacijski broj, Croatian identification number).

    The personal identification number is used to identify persons and legal
    entities in Croatia. It has 11 digits (sometimes prefixed by HR), contains
    no personal information and uses the ISO 7064 Mod 11, 10 checksum algorithm.
*)

exception Invalid_format
exception Invalid_length
exception Invalid_checksum

val compact : string -> string
(** Convert the number to the minimal representation. This strips the number of
    any valid separators and removes surrounding whitespace. *)

val validate : string -> string
(** Check if the number is a valid OIB number. This checks the length,
    formatting and check digit.

    @raise Invalid_checksum if the checksum fails *)

val validate_result : string -> (string, Tools.Error.t) result
(** Same as {!validate} but returns a [result] instead of raising exceptions. *)

val is_valid : string -> bool
(** Check if the number is a valid OIB number. *)
