(** ISO 11649 (Structured Creditor Reference).

    The ISO 11649 structured creditor number consists of 'RF' followed by two
    check digits and up to 21 digits. The number may contain letters.

    The reference number is validated by moving RF and the check digits to the
    end of the number, and checking that the ISO 7064 Mod 97, 10 checksum of
    this string is 1.

    More information:
    - https://en.wikipedia.org/wiki/Creditor_Reference

    Format: RF + 2 check digits + up to 21 alphanumeric characters Total length:
    5-25 characters *)

exception Invalid_checksum
exception Invalid_length
exception Invalid_format

val compact : string -> string
(** Convert the number to the minimal representation. This strips the number of
    any invalid separators and removes surrounding whitespace.

    Example: [compact "RF18 5390 0754 7034"] returns ["RF18539007547034"] *)

val validate : string -> string
(** Check if the number provided is a valid ISO 11649 structured creditor
    reference number. Returns the normalized number if valid.

    if the number has an invalid format (doesn't start with RF)
    @raise Invalid_length if the number has an invalid length *)

val validate_result : string -> (string, Tools.Error.t) result
(** Same as {!validate} but returns a [result] instead of raising exceptions. *)

val is_valid : string -> bool
(** Check if the number provided is a valid ISO 11649 structured creditor
    number. Returns [true] if valid, [false] otherwise. *)

val format : string -> string
(** Format the number provided for output. Blocks of 4 characters, the last
    block can be less than 4 characters.

    Example: [format "RF18539007547034"] returns ["RF18 5390 0754 7034"] *)
