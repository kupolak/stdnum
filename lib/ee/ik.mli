(** Isikukood (Estonian Personal ID number).

    The number consists of 11 digits: the first indicates the gender and century
    the person was born in, the following 6 digits the birth date, followed by a
    3 digit serial and a check digit.

    More information:
    - https://www.riigiteataja.ee/akt/106032012004 *)

exception Invalid_format
(** Exception raised when the IK has invalid format. *)

exception Invalid_length
(** Exception raised when the IK has invalid length. *)

exception Invalid_component
(** Exception raised when the IK has an invalid date of birth or century/gender
    digit. *)

exception Invalid_checksum
(** Exception raised when the checksum validation fails. *)

val compact : string -> string
(** Convert the number to the minimal representation. This strips the number of
    any valid separators and removes surrounding whitespace. *)

val get_birth_date : string -> int * int * int
(** Split the date parts from the number and return the birth date (year, month,
    day). *)

val get_gender : string -> string
(** Get the person's birth gender ("M" or "F"). *)

val calc_check_digit : string -> string
(** Calculate the check digit. *)

val validate : string -> string
(** Check if the number provided is valid. This checks the length, formatting,
    embedded date and check digit.

    @raise Invalid_format if the number contains invalid characters
    @raise Invalid_length if the length is not 11
    @raise Invalid_component if the date of birth or gender is invalid
    @raise Invalid_checksum if the checksum fails *)

val is_valid : string -> bool
(** Check if the number provided is valid. *)
