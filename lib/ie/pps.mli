(** PPS No (Personal Public Service Number, Irish personal number).

    The Personal Public Service number consists of 7 digits, and one or
    two letters. The first letter is a check character.
    When present (which should be the case for new numbers as of 2013),
    the second letter can be 'A' (for individuals) or 'H' (for
    non-individuals, such as limited companies, trusts, partnerships
    and unincorporated bodies). As of 2024, B was accepted as a second
    letter on all new PPS numbers.

    Pre-2013 values may have 'W', 'T', or 'X' as the second letter ;
    it is ignored by the check. *)

exception Invalid_format
(** Exception raised when the number has invalid format. *)

exception Invalid_length
(** Exception raised when the number has invalid length. *)

exception Invalid_checksum
(** Exception raised when the checksum validation fails. *)

val compact : string -> string
(** Convert the number to the minimal representation. This strips the
    number of any valid separators and removes surrounding whitespace. *)

val validate : string -> string
(** Check if the number provided is a valid PPS number. This checks the
    length, formatting and check digit.

    @raise Invalid_format if the number contains invalid characters
    @raise Invalid_length if the length is not correct
    @raise Invalid_checksum if the checksum fails *)

val is_valid : string -> bool
(** Check if the number provided is a valid PPS number. This checks the
    length, formatting and check digit. *)
