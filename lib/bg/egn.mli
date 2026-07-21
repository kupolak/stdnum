(** EGN (ЕГН, Единен граждански номер, Bulgarian personal identity codes).

    It is a 10-digit number of which the first 6 digits denote the person's
    birth date, the next three digits represent a birth order number from which
    the person's gender can be determined and the last digit is a check digit.

    More information:
    - https://en.wikipedia.org/wiki/Uniform_civil_number *)

exception Invalid_format
(** Exception raised when the EGN has invalid format. *)

exception Invalid_length
(** Exception raised when the EGN has invalid length. *)

exception Invalid_component
(** Exception raised when the EGN has invalid date component. *)

exception Invalid_checksum
(** Exception raised when the checksum validation fails. *)

val compact : string -> string
(** Convert the number to the minimal representation. This strips the number of
    any valid separators and removes surrounding whitespace. *)

val calc_check_digit : string -> string
(** Calculate the check digit. The number passed should not have the check digit
    included. *)

val get_birth_date : string -> int * int * int
(** Split the date parts from the number and return the birth date as a tuple of
    (year, month, day). *)

val validate : string -> string
(** Check if the number is a valid national identification number. This checks
    the length, formatting, embedded date and check digit.

    @raise Invalid_format if the number contains invalid characters
    @raise Invalid_length if the length is not 10
    @raise Invalid_component if the embedded date is invalid
    @raise Invalid_checksum if the checksum fails *)

val is_valid : string -> bool
(** Check if the number is a valid national identification number. *)
