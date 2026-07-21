(** Euro banknote serial numbers.

    The serial number consists of one letter and 11 digits, or two letters and
    10 digits for the new series banknotes.

    More information:
    - https://en.wikipedia.org/wiki/Euro_banknotes#Serial_number *)

exception Invalid_format
exception Invalid_length
exception Invalid_component
exception Invalid_checksum

val compact : string -> string
(** Convert the number to the minimal representation. This strips the number of
    any valid separators and removes surrounding whitespace. *)

val checksum : string -> int
(** Calculate the checksum over the number. *)

val validate : string -> string
(** Check if the number is a valid banknote serial number.

    @raise Invalid_checksum if the checksum fails *)

val validate_result : string -> (string, Tools.Error.t) result
(** Same as {!validate} but returns a [result] instead of raising exceptions. *)

val is_valid : string -> bool
(** Check if the number is a valid banknote serial number. *)
