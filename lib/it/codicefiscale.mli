(** Codice Fiscale (Italian tax code for individuals).

    The Codice Fiscale is an alphanumeric code of 16 characters used to identify
    individuals residing in Italy or 11 digits for non-individuals in which case
    it matches the Imposta sul valore aggiunto.

    The 16 digit number consists of three characters derived from the person's
    last name, three from the person's first name, five that hold information on
    the person's gender and birth date, four that represent the person's place of
    birth and one check digit.

    More information:
    - https://it.m.wikipedia.org/wiki/Codice_fiscale *)

exception Invalid_format
exception Invalid_length
exception Invalid_checksum
exception Invalid_component

val compact : string -> string
(** Remove any formatting characters from the number and return a clean string. *)

val calc_check_digit : string -> string
(** Compute the control code for the given personal number. The passed
    number should be the first 15 characters of a fiscal code. *)

val get_birth_date : ?minyear:int -> string -> float * Unix.tm
(** Get the birth date from the person's fiscal code.

    Only the last two digits of the year are stored in the number. The dates
    will be returned in the range from minyear to minyear + 100.
    Default minyear is 1920.

    @raise Invalid_component if the number is not 16 characters or date is invalid *)

val get_gender : string -> string
(** Get the gender of the person's fiscal code. Returns "M" or "F".
    @raise Invalid_component if the number is not 16 characters *)

val validate : string -> string
(** Check if the given fiscal code is valid. This checks the length and
    whether the check digit is correct. For 11-digit numbers, validates as IVA.
    @raise Invalid_length if the number length is invalid
    @raise Invalid_format if the number format is invalid
    @raise Invalid_checksum if the check digit is invalid
    @raise Invalid_component if the birth date is invalid *)

val is_valid : string -> bool
(** Check if the given fiscal code is valid. *)
