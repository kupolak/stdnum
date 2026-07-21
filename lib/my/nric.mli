(** NRIC No. (Malaysian National Registration Identity Card Number).

    The NRIC No. is the unique identifier for issued to Malaysian citizens and
    permanent residents.

    The number consist of 12 digits in three sections. The first 6 digits
    represent the birth date, followed by two digits representing the birth
    place and finally four digits. The gender of a person can be derived from
    the last digit: odd numbers for males and even numbers for females. *)

exception Invalid_format
(** Exception raised when the number has invalid format. *)

exception Invalid_length
(** Exception raised when the number has invalid length. *)

exception Invalid_component
(** Exception raised when a component of the number is invalid. *)

val compact : string -> string
(** Convert the number to the minimal representation. This strips the number of
    any valid separators and removes surrounding whitespace. *)

val get_birth_date : string -> int * int * int
(** Split the date parts from the number and return the birth date. Note that in
    some cases it may return the registration date instead of the birth date and
    it may be a century off. *)

val get_birth_place : string -> string
(** Use the number to look up the place of birth of the person. *)

val validate : string -> string
(** Check if the number is a valid NRIC number. This checks the length,
    formatting and birth date and place.

    @raise Invalid_format if the number contains invalid characters
    @raise Invalid_length if the length is not 12
    @raise Invalid_component if the date or place is invalid *)

val is_valid : string -> bool
(** Check if the number is a valid NRIC number. *)

val format : string -> string
(** Reformat the number to the standard presentation format. *)
