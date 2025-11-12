(** BIS (Belgian BIS number).

    The BIS number (BIS-nummer, Numéro BIS) is a unique identification number
    for individuals who are not registered in the National Register, but who
    still have a relationship with the Belgian government.
    This includes frontier workers, persons who own property in Belgium,
    persons with Belgian social security rights but who do not reside in Belgium, etc.

    The number is issued by the Belgian Crossroads Bank for Social Security and is
    constructed much in the same way as the Belgian National Number, consisting of
    11 digits, encoding the person's date of birth and gender, a checksum, etc.
    Other than with the national number though, the month of birth of the BIS number
    is increased by 20 or 40, depending on whether the sex of the person was known
    at the time or not. *)

exception Invalid_length
exception Invalid_format
exception Invalid_checksum
exception Invalid_component of string

val compact : string -> string
(** Convert the number to the minimal representation. This strips the number
    of any valid separators and removes surrounding whitespace. *)

val validate : string -> string
(** Check if the number is a valid BIS Number. Returns the compacted number
    if valid, raises an exception otherwise. *)

val is_valid : string -> bool
(** Check if the number is a valid BIS Number. Returns true if valid,
    false otherwise. *)

val format : string -> string
(** Reformat the number to the standard presentation format. *)

val get_birth_year : string -> int option
(** Return the year of the birth date, or None if unknown. *)

val get_birth_month : string -> int option
(** Return the month of the birth date, or None if unknown. *)

val get_birth_date : string -> (int * int * int) option
(** Return the date of birth as (year, month, day), or None if not fully known. *)

val get_gender : string -> string option
(** Get the person's gender ('M' or 'F'), which for BIS numbers is only known
    if the month was incremented with 40. Returns None if gender is unknown. *)
