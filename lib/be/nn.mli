(** NN, NISS, RRN (Belgian national number).

    The national registration number (Rijksregisternummer, Numéro de registre
    national, Nationalregisternummer) is a unique identification number of
    natural persons who are registered in Belgium.

    The number consists of 11 digits and includes the person's date of birth and
    gender. It encodes the date of birth in the first 6 digits in the format
    YYMMDD. The following 3 digits represent a counter of people born on the same
    date, separated by sex (odd for male and even for females respectively). The
    final 2 digits form a check number based on the 9 preceding digits. *)

exception Invalid_length
exception Invalid_format
exception Invalid_checksum
exception Invalid_component of string

val compact : string -> string
(** Convert the number to the minimal representation. This strips the number
    of any valid separators and removes surrounding whitespace. *)

val validate : string -> string
(** Check if the number is a valid National Number. Returns the compacted number
    if valid, raises an exception otherwise. *)

val is_valid : string -> bool
(** Check if the number is a valid National Number. Returns true if valid,
    false otherwise. *)

val format : string -> string
(** Reformat the number to the standard presentation format (YY.MM.DD-NNN.CC). *)

val get_birth_year : string -> int option
(** Return the year of the birth date, or None if unknown. *)

val get_birth_month : string -> int option
(** Return the month of the birth date, or None if unknown. *)

val get_birth_date : string -> (int * int * int) option
(** Return the date of birth as (year, month, day), or None if not fully known. *)

val get_gender : string -> string
(** Get the person's gender ('M' or 'F'). *)

val get_birth_date_parts : string -> int option * int option * int option
(** Internal function to get birth date parts. Returns (year, month, day) with None for unknown parts.
    This function is exposed for use by the bis module. *)
