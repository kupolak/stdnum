(** PEID (Liechtenstein tax code for individuals and entities).

    The Personenidentifikationsnummer (PEID) is an numeric code up to 12 digits
    used to identify entities and individuals residing in Liechtenstein.

    More information:
    - https://www.oera.li/
    - https://www.oecd.org/tax/automatic-exchange/crs-implementation-and-assistance/tax-identification-numbers/LIECHTENSTEIN%20TIN.pdf
*)

exception Invalid_format
exception Invalid_length

val compact : string -> string
(** Convert the number to the minimal representation. This strips the number of
    any valid separators and removes surrounding whitespace. *)

val validate : string -> string
(** Check if the given fiscal code is valid.

    @raise Invalid_length if the length is not between 4 and 12 digits *)

val validate_result : string -> (string, Tools.Error.t) result
(** Same as {!validate} but returns a [result] instead of raising exceptions. *)

val is_valid : string -> bool
(** Check if the given fiscal code is valid. *)
