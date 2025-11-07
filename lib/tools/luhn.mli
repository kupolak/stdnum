(** The Luhn and Luhn mod N algorithms.

    The Luhn algorithm is used to detect most accidental errors in various
    identification numbers. It can work with different alphabets using the
    Luhn mod N algorithm.
*)

exception Invalid_format
(** Exception raised when the number format is invalid (e.g., empty string). *)

exception Invalid_checksum
(** Exception raised when the Luhn checksum is invalid. *)

val checksum : ?alphabet:string -> string -> int
(** Calculate the Luhn checksum over the provided number. The checksum is
    returned as an integer. Valid numbers should have a checksum of 0.

    @param alphabet Optional alphabet string (defaults to "0123456789") *)

val validate : ?alphabet:string -> string -> string
(** Check if the number provided passes the Luhn checksum. Returns the number
    if valid.

    @param alphabet Optional alphabet string (defaults to "0123456789")
    @raise Invalid_format if the number is empty
    @raise Invalid_checksum if the checksum is not 0 *)

val is_valid : ?alphabet:string -> string -> bool
(** Check if the number passes the Luhn checksum.
    Returns [true] if valid, [false] otherwise.

    @param alphabet Optional alphabet string (defaults to "0123456789") *)

val calc_check_digit : ?alphabet:string -> string -> string
(** Calculate the extra digit that should be appended to the number to make it
    a valid number.

    @param alphabet Optional alphabet string (defaults to "0123456789") *)
