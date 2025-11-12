(** Belgian SSN (Social Security Number).

    The Belgian SSN is a wrapper that accepts either a Belgian national number
    (nn) or a BIS number. The validation logic first tries to validate as a BIS
    number, and if that fails with an Invalid_component error, it tries to
    validate as a regular national number. *)

exception Invalid_length
exception Invalid_format
exception Invalid_checksum
exception Invalid_component

val compact : string -> string
(** Convert the number to the minimal representation. This strips the
    number of any valid separators and removes surrounding whitespace. *)

val validate : string -> string
(** Check if the number is a valid Belgian SSN. This searches for
    the proper sub-type and validates using that. Returns the compacted
    number if valid, raises an exception otherwise. *)

val is_valid : string -> bool
(** Check if the number is a valid Belgian SSN. Returns true if valid,
    false otherwise. *)

val guess_type : string -> string option
(** Return the Belgian SSN type for which this number is valid.
    Returns Some "bis" for BIS numbers, Some "nn" for national numbers,
    or None if the number is invalid. *)

val format : string -> string
(** Reformat the number to the standard presentation format. *)

val get_birth_date : string -> string option
(** Get the person's birth date in YYYY-MM-DD format, or None if the
    birth date is not known. *)

val get_birth_year : string -> int option
(** Get the person's birth year, or None if the birth year is not known. *)

val get_birth_month : string -> int option
(** Get the person's birth month, or None if the birth month is not known. *)

val get_gender : string -> string option
(** Get the person's gender ('M' or 'F'), which for BIS numbers is only known
    if the month was incremented with 40. Returns None if gender is unknown. *)
