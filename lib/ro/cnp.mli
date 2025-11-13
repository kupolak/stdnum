(** Romanian CNP (Cod Numeric Personal, Romanian Numerical Personal Code).

    The CNP is a 13 digit number that includes information on the person's
    gender, birth date and county zone.

    The format is: SYYMMDDJJNNNC where:
    - S: Gender and century (1-9)
      1,2 = born 1900-1999 (male/female)
      3,4 = born 1800-1899 (male/female)
      5,6 = born 2000-2099 (male/female)
      7,8 = foreign resident
      9 = other foreigner
    - YY: Year (00-99)
    - MM: Month (01-12)
    - DD: Day (01-31)
    - JJ: County code (01-52, 70, 80-83)
    - NNN: Sequential number (001-999)
    - C: Check digit

    More information:
    - https://ro.wikipedia.org/wiki/Cod_numeric_personal
    - https://github.com/vimishor/cnp-spec/blob/master/spec.md
*)

exception Invalid_length
(** Exception raised when the number has an invalid length. *)

exception Invalid_format
(** Exception raised when the number has an invalid format. *)

exception Invalid_component
(** Exception raised when a component (gender, date, or county) is invalid. *)

exception Invalid_checksum
(** Exception raised when the checksum is invalid. *)

val compact : string -> string
(** Convert the number to the minimal representation. This strips the
    number of any valid separators and removes surrounding whitespace.

    Example: [compact "163 061 512 3457"] returns ["1630615123457"] *)

val get_birth_date : string -> int * int * int
(** Extract and validate the birth date from the CNP.
    Returns a tuple of (year, month, day).

    @raise Invalid_component if the date is invalid *)

val get_county : string -> string
(** Get the county name from the CNP.

    @raise Invalid_component if the county code is invalid *)

val validate : string -> string
(** Check if the number is a valid CNP. This checks the length,
    formatting, gender/century indicator, birth date, county code,
    and check digit. Returns the normalized number if valid.

    @raise Invalid_format if the number has an invalid format
    @raise Invalid_length if the number has an invalid length
    @raise Invalid_component if the gender, date, or county is invalid
    @raise Invalid_checksum if the check digit is invalid *)

val is_valid : string -> bool
(** Check if the number is a valid CNP.
    Returns [true] if valid, [false] otherwise. *)
