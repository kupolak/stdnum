(** Fødselsnummer (Norwegian birth number, the national identity number).

    The Fødselsnummer is an eleven-digit number that is built up of the date of
    birth of the person, a serial number and two check digits. *)

exception Invalid_component
exception Invalid_length
exception Invalid_checksum
exception Invalid_format

val compact : string -> string
(** Convert the number to the minimal representation. This strips the
    number of any valid separators and removes surrounding whitespace. *)

val get_gender : string -> char
(** Get the person's birth gender ('M' or 'F'). *)

val get_birth_date : string -> (float * Unix.tm) option
(** Determine and return the birth date as a Unix time structure.
    Returns Some (time, tm) where time is seconds since epoch and tm is the Unix.tm structure. *)

val validate : string -> string
(** Check if the number is a valid birth number.
    Raises Invalid_format, Invalid_length, Invalid_checksum, or Invalid_component
    if the number is not valid. *)

val is_valid : string -> bool
(** Check if the number is a valid birth number. Returns true if valid, false otherwise. *)

val format : string -> string
(** Reformat the number to the standard presentation format (DDMMYY NNNNN). *)
