(** SEDOL number (Stock Exchange Daily Official List number).

    The SEDOL number is a security identifier used in the United Kingdom and
    Ireland assigned by the London Stock Exchange. A SEDOL is seven characters
    in length consisting of six alphanumeric digits, followed by a check digit.

    More information:
    - https://en.wikipedia.org/wiki/SEDOL *)

exception Invalid_format
exception Invalid_length
exception Invalid_checksum

val compact : string -> string
(** Convert the number to the minimal representation. This strips the number of
    any valid separators and removes surrounding whitespace. *)

val calc_check_digit : string -> string
(** Calculate the check digits for the number. *)

val validate : string -> string
(** Check if the number is valid. This checks the length and check digit.

    @raise Invalid_checksum if the checksum fails *)

val validate_result : string -> (string, Tools.Error.t) result
(** Same as {!validate} but returns a [result] instead of raising exceptions. *)

val is_valid : string -> bool
(** Check if the number is valid. *)

val to_isin : string -> string
(** Convert the number to an ISIN. *)
