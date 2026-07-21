(** ID number (Mauritian national identifier).

    The Mauritian national ID number is a unique 14 alphanumeric identifier
    assigned at birth to identify individuals. It is displayed on the National
    Identity Card.

    The number consists of one alphabetic character and thirteen digits:
    - the first character of the person's surname at birth
    - 2 digits for day of birth
    - 2 digits for month of birth
    - 2 digits for year of birth
    - 6 digit unique id
    - a check digit

    More information:
    - https://mnis.govmu.org/English/ID%20Card/Pages/default.aspx *)

exception Invalid_format
(** Exception raised when the number has invalid format. *)

exception Invalid_length
(** Exception raised when the number has invalid length. *)

exception Invalid_checksum
(** Exception raised when the checksum validation fails. *)

exception Invalid_component
(** Exception raised when a component of the number is invalid. *)

val compact : string -> string
(** Convert the number to the minimal representation. This strips
    surrounding whitespace and separation dash. *)

val calc_check_digit : string -> string
(** Calculate the check digit for the number. *)

val get_date : string -> int * int * int
(** Convert the part of the number that represents a date into a
    date tuple (year, month, day). Note that the century may be incorrect. *)

val validate : string -> string
(** Check if the number is a valid ID number.

    @raise Invalid_format if the number contains invalid characters
    @raise Invalid_length if the length is not 14
    @raise Invalid_checksum if the checksum fails
    @raise Invalid_component if the date component is invalid *)

val is_valid : string -> bool
(** Check if the number provided is a valid ID number. *)
