(** Finnish Association Identifier.

    The number consists of 1 to 6 digits that are normally separated with a dot
    in groups of 0-3 and 0-3 numbers. E.g. 123.123, 12.123, 1.123, 123 or 1. *)

exception Invalid_format
(** Exception raised when the number has invalid format. *)

exception Invalid_length
(** Exception raised when the number has invalid length. *)

exception Invalid_component
(** Exception raised when the number is too small and not in the known low numbers list. *)

val compact : string -> string
(** Convert the number to the minimal representation. This strips the
    number of any valid separators and removes surrounding whitespace. *)

val validate : string -> string
(** Check if the number is a valid Finnish association register number.
    This checks the length and format.

    @raise Invalid_format if the number contains invalid characters
    @raise Invalid_length if the length is not between 1 and 6
    @raise Invalid_component if the number is less than 100 and not valid *)

val is_valid : string -> bool
(** Check if the number is a valid association register number. *)

val format : string -> string
(** Reformat the number to the standard presentation format. *)
