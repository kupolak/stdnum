(** ISO 7064 Mod 37, 36 algorithm.

    The Mod 37, 36 algorithm uses an alphanumeric check digit and the number
    itself may also contain letters.

    By changing the alphabet this can be turned into any Mod x+1, x
    algorithm. For example Mod 11, 10.
*)

exception Invalid_format
(** Exception raised when the number format is invalid. *)

exception Invalid_checksum
(** Exception raised when the checksum is invalid. *)

exception Not_found
(** Exception raised when a character is not found in the alphabet. *)

val alphabet : string
(** Default alphabet used for checksum calculation: '0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ' *)

val index : string -> char -> int
(** Find the index of a character in a string. *)

val checksum : ?alphabet:string -> string -> int
(** Calculate the checksum. A valid number should have a checksum of 1. *)

val calc_check_digit : ?alphabet:string -> string -> char
(** Calculate the extra digit that should be appended to the number to make it
    a valid number. *)

val validate : ?alphabet:string -> string -> string
(** Check whether the check digit is valid. Returns the number if valid.

    @raise Invalid_format if the format is invalid
    @raise Invalid_checksum if the checksum is not 1 *)

val is_valid : ?alphabet:string -> string -> bool
(** Check whether the check digit is valid. Returns [true] if valid, [false]
    otherwise. *)
