(** Czech RČ (Rodné číslo, birth number).

    The RČ (Rodné číslo) is a unique identifier for Czech individuals, consisting
    of 9 or 10 digits. The number contains the birth date encoded in the first
    6 digits (YYMMDD format, where MM is increased by 50 for women, and can be
    increased by 20 for males or 70 for women for individuals born after 2004).

    The number uses a modulo 11 checksum algorithm for validation (10-digit numbers).
    9-digit numbers were used before 1954 and do not have a check digit.

    This number is identical to the Slovak counterpart.
*)

exception Invalid_length
(** Exception raised when the number has an invalid length (not 9 or 10 digits),
    or when a 9-digit number is used after January 1st 1954. *)

exception Invalid_format
(** Exception raised when the number contains non-digit characters. *)

exception Invalid_checksum
(** Exception raised when the modulo 11 checksum is invalid. *)

exception Invalid_component
(** Exception raised when the birth date components are invalid. *)

val compact : string -> string
(** Convert the number to the minimal representation. This strips spaces,
    slashes, and removes surrounding whitespace.

    Example: [compact "710319/2745"] returns ["7103192745"] *)

val get_birth_date : string -> int * int * int
(** Split the date parts from the number and return the birth date as (year, month, day).
    Females have 50 added to the month value. 20 is added when the serial
    overflows (since 2004). 9 digit numbers were used until January 1st 1954.

    @raise Invalid_component if the date components form an invalid date
    @raise Invalid_length if a 9-digit number is used after 1953 *)

val validate : string -> string
(** Check if the number is a valid birth number. This checks the length,
    formatting, birth date validity, and check digit (for 10-digit numbers).
    Returns the normalized number if valid.

    @raise Invalid_format if the number contains non-digit characters
    @raise Invalid_length if the number is not 9 or 10 digits, or if a 9-digit number is after 1953
    @raise Invalid_checksum if the modulo 11 checksum is invalid
    @raise Invalid_component if the birth date components are invalid *)

val is_valid : string -> bool
(** Check if the number is a valid birth number.
    Returns [true] if valid, [false] otherwise. *)

val format : string -> string
(** Reformat the number to the standard presentation format (XXXXXX/XXXX or XXXXXX/XXX).

    Example: [format "7103192745"] returns ["710319/2745"] *)
