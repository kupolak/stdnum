(*
RTN (Routing Transit Number).

The routing transit number is a nine digit number used in the US banking
system for processing deposits between banks.

The last digit is a checksum.

More information:

* https://en.wikipedia.org/wiki/ABA_routing_transit_number
*)

exception Invalid_length
(** Exception raised when the RTN has an invalid length. *)

exception Invalid_format
(** Exception raised when the RTN has an invalid format. *)

exception Invalid_checksum
(** Exception raised when the RTN has an invalid checksum. *)

val validate : string -> string
(** Check if the number is a valid routing number. This checks the length
    and check digit. Returns the normalized number if valid.
    @raise Invalid_length if the number length is not 9
    @raise Invalid_format if the number contains non-digit characters
    @raise Invalid_checksum if the check digit is invalid *)

val is_valid : string -> bool
(** Check if the number is a valid RTN. Returns true if valid, false otherwise. *)

val format : string -> string
(** Reformat the number to the minimal representation. *)

val compact : string -> string
(** [compact number] removes spaces and dashes from the number. *)

val calc_check_digit : string -> string
(** [calc_check_digit number] calculates the check digit for the given 8-digit number.
    The number passed should not have the check digit included.
    @raise Invalid_length if the number is not 8 digits
    @raise Invalid_format if the number contains non-digit characters *)
