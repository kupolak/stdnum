(** ISO 7064 Mod 11, 2 algorithm.

    The Mod 11, 2 algorithm is a simple module 11 checksum where the check
    digit can be an X to make the number valid.
*)

exception Invalid_format
(** Exception raised when the number format is invalid. *)

exception Invalid_checksum
(** Exception raised when the checksum is invalid. *)

val checksum : string -> int
(** Calculate the checksum. A valid number should have a checksum of 1. *)

val calc_check_digit : string -> string
(** Calculate the extra digit that should be appended to the number to make it
    a valid number. Returns 'X' if the check digit is 10, otherwise returns
    the digit as a string. *)

val validate : string -> string
(** Check whether the check digit is valid. Returns the number if valid.

    @raise Invalid_format if the format is invalid
    @raise Invalid_checksum if the checksum is not 1 *)

val is_valid : string -> bool
(** Check whether the check digit is valid. Returns [true] if valid, [false]
    otherwise. *)
