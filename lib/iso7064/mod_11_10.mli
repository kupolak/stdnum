(** ISO 7064 Mod 11, 10 algorithm.

    The Mod 11, 10 algorithm uses calculations modulo 11 and modulo 10 to
    determine a checksum. This is used in various identification number systems.
*)

exception Invalid_format
(** Exception raised when the number format is invalid. *)

exception Invalid_checksum
(** Exception raised when the checksum is invalid. *)

val checksum : string -> int
(** Calculate the checksum. A valid number should have a checksum of 1. *)

val calc_check_digit : string -> string
(** Calculate the extra digit that should be appended to the number to make it
    a valid number. *)

val validate : string -> string
(** Check whether the check digit is valid. Returns the number if valid.

    @raise Invalid_format if the format is invalid
    @raise Invalid_checksum if the checksum is not 1 *)

val is_valid : string -> bool
(** Check whether the check digit is valid. Returns [true] if valid, [false]
    otherwise. *)
