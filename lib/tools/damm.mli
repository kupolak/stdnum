(** The Damm checksum algorithm.

    The Damm algorithm is a check digit algorithm that detects all single-digit
    errors and all adjacent transposition errors. It is based on an anti-symmetric
    quasigroup of order 10 and uses a substitution table.
*)

exception Invalid_format
(** Exception raised when the number format is invalid (e.g., empty string). *)

exception Invalid_checksum
(** Exception raised when the Damm checksum is invalid. *)

val default_table : int array array
(** The default Damm operation table from Wikipedia. *)

val checksum : ?table:int array array -> string -> int
(** Calculate the Damm checksum over the provided number. The checksum is
    returned as an integer value and should be 0 when valid.

    @param table Optional custom operation table (defaults to Wikipedia table) *)

val validate : ?table:int array array -> string -> string
(** Check if the number provided passes the Damm algorithm. Returns the number
    if valid.

    @param table Optional custom operation table (defaults to Wikipedia table)
    @raise Invalid_format if the number is empty
    @raise Invalid_checksum if the checksum is not 0 *)

val is_valid : ?table:int array array -> string -> bool
(** Check if the number provided passes the Damm algorithm.
    Returns [true] if valid, [false] otherwise.

    @param table Optional custom operation table (defaults to Wikipedia table) *)

val calc_check_digit : ?table:int array array -> string -> string
(** Calculate the extra digit that should be appended to the number to make it
    a valid number.

    @param table Optional custom operation table (defaults to Wikipedia table) *)
