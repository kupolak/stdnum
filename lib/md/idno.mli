(** IDNO (Moldavian company identification number).

    The IDNO is used in Moldavia as unique identifier for legal entities. The
    number consists of 13 digits. The first digit identifies the registry,
    followed by three digits for the year the code was assigned. The number ends
    with five identifier digits and a check digit.

    More information:
    - https://www.idno.md *)

exception Invalid_format
exception Invalid_length
exception Invalid_checksum

val compact : string -> string
(** Convert the number to the minimal representation. This strips the number of
    any valid separators and removes surrounding whitespace. *)

val calc_check_digit : string -> string
(** Calculate the check digit. *)

val validate : string -> string
(** Check if the number provided is valid. This checks the length, formatting
    and check digit.

    @raise Invalid_checksum if the checksum fails *)

val validate_result : string -> (string, Tools.Error.t) result
(** Same as {!validate} but returns a [result] instead of raising exceptions. *)

val is_valid : string -> bool
(** Check if the number provided is valid. This checks the length, formatting
    and check digit. *)
