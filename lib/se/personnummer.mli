(** Swedish Personnummer (personal identity number).

    The Swedish Personnummer is assigned at birth to all Swedish nationals and to
    immigrants for tax and identification purposes. The number consists of 10 or
    12 digits and starts with the birth date, followed by a serial and a check
    digit.

    The format can be YYMMDD-NNNN or YYYYMMDD-NNNN where:
    - YYMMDD or YYYYMMDD is the birth date
    - NNNN is a serial number (3 digits) and a check digit (1 digit)
    - The separator can be '-' for people under 100 years old or '+' for people
      100 years or older

    More information:
    - https://en.wikipedia.org/wiki/Personal_identity_number_(Sweden)
*)

exception Invalid_length
(** Exception raised when the number has an invalid length (not 11 or 13 characters). *)

exception Invalid_format
(** Exception raised when the number has an invalid format. *)

exception Invalid_checksum
(** Exception raised when the Luhn checksum is invalid. *)

exception Invalid_component
(** Exception raised when the birth date is invalid. *)

val compact : string -> string
(** Convert the number to the minimal representation. This strips spaces and colons,
    and normalizes the separator position.

    Example: [compact "8803200016"] returns ["880320-0016"] *)

val get_birth_date : string -> (float * Unix.tm) option
(** Determine the birth date from the number.

    For people aged 100 and up, the minus/dash in the personnummer is changed to a plus
    on New Year's Eve the year they turn 100.

    @raise Invalid_component if the date components are invalid
    @return Some (time, tm) tuple or raises Invalid_component *)

val get_gender : string -> char
(** Get the person's birth gender ('M' or 'F').

    Example: [get_gender "890102-3286"] returns ['F'] *)

val validate : string -> string
(** Check if the number is a valid identity number. This checks the length,
    format, birth date validity, and Luhn check digit. Returns the normalized
    number if valid.

    @raise Invalid_format if the number has an invalid format
    @raise Invalid_length if the number length is not 11 or 13 characters
    @raise Invalid_checksum if the Luhn checksum is invalid
    @raise Invalid_component if the birth date is invalid *)

val is_valid : string -> bool
(** Check if the number is a valid identity number.
    Returns [true] if valid, [false] otherwise. *)

val format : string -> string
(** Reformat the number to the standard presentation format.

    Example: [format "8803200016"] returns ["880320-0016"] *)
