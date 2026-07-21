(** RČ (Rodné číslo, the Slovak birth number).

    The birth number (RČ, Rodné číslo) is the Slovak national identifier. The
    number can be 9 or 10 digits long. Numbers given out after January 1st 1954
    should have 10 digits. The number includes the birth date of the person and
    their gender.

    This number is identical to the Czech counterpart. *)

exception Invalid_format
(** Exception raised when the number has invalid format. *)

exception Invalid_length
(** Exception raised when the number has invalid length. *)

exception Invalid_checksum
(** Exception raised when the checksum validation fails. *)

exception Invalid_component
(** Exception raised when a component of the number is invalid. *)

val compact : string -> string
(** Convert the number to the minimal representation. This strips the number of
    any valid separators and removes surrounding whitespace. *)

val validate : string -> string
(** Check if the number is a valid Slovak birth number. *)

val is_valid : string -> bool
(** Check if the number is a valid Slovak birth number. *)

val format : string -> string
(** Reformat the number to the standard presentation format. *)
