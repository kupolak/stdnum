(** The Verhoeff checksum algorithm.

    The Verhoeff algorithm is a checksum algorithm that catches most common
    (typing) errors in numbers. It uses multiplication and permutation tables
    and is more complex than the Luhn algorithm but catches more errors. *)

exception Invalid_format
exception Invalid_checksum

val multiplication_table : int array array
(** The multiplication table used in the Verhoeff algorithm. *)

val permutation_table : int array array
(** The permutation table used in the Verhoeff algorithm. *)

val checksum : string -> int
(** Calculate the Verhoeff checksum over the provided number. The checksum is
    returned as an integer. Valid numbers should have a checksum of 0. *)

val validate : string -> string
(** Check if the number provided passes the Verhoeff checksum. Returns the
    number if valid.

    @raise Invalid_checksum if the checksum is not 0 *)

val validate_result : string -> (string, Error.t) result
(** Same as {!validate} but returns a [result] instead of raising exceptions. *)

val is_valid : string -> bool
(** Check if the number provided passes the Verhoeff checksum. Returns [true] if
    valid, [false] otherwise. *)

val calc_check_digit : string -> string
(** Calculate the extra digit that should be appended to the number to make it a
    valid number. *)
