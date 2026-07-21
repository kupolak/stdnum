(** The Verhoeff algorithm.

    The Verhoeff algorithm is a checksum algorithm that should catch most common
    (typing) errors in numbers. The algorithm uses two tables for permutations
    and multiplications and as a result is more complex than the Luhn algorithm.

    More information:
    - https://en.wikipedia.org/wiki/Verhoeff_algorithm
    - https://en.wikibooks.org/wiki/Algorithm_Implementation/Checksums/Verhoeff_Algorithm *)

exception Invalid_format
(** Exception raised when the number has invalid format. *)

exception Invalid_checksum
(** Exception raised when the checksum validation fails. *)

val checksum : string -> int
(** Calculate the Verhoeff checksum over the provided number. The checksum
    is returned as an int. Valid numbers should have a checksum of 0. *)

val validate : string -> string
(** Check if the number provided passes the Verhoeff checksum. *)

val is_valid : string -> bool
(** Check if the number provided passes the Verhoeff checksum. *)

val calc_check_digit : string -> string
(** Calculate the extra digit that should be appended to the number to
    make it a valid number. *)
