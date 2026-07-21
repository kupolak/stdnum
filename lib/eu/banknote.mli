(** Euro banknote serial numbers.

    The serial number consists of one letter and 11 digits, or two letters and
    10 digits for the new series banknotes.

    More information:
    - https://en.wikipedia.org/wiki/Euro_banknotes#Serial_number *)

exception Invalid_format
(** Exception raised when the number has invalid format. *)

exception Invalid_length
(** Exception raised when the number has invalid length. *)

exception Invalid_component
(** Exception raised when the starting letter is invalid. *)

exception Invalid_checksum
(** Exception raised when the checksum validation fails. *)

val compact : string -> string
(** Convert the number to the minimal representation. This strips the number of
    any valid separators and removes surrounding whitespace. *)

val checksum : string -> int
(** Calculate the checksum over the number. *)

val validate : string -> string
(** Check if the number is a valid banknote serial number.

    @raise Invalid_format if the number contains invalid characters
    @raise Invalid_length if the length is not 12
    @raise Invalid_component if the starting letter is invalid
    @raise Invalid_checksum if the checksum fails *)

val is_valid : string -> bool
(** Check if the number is a valid banknote serial number. *)
