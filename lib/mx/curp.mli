(** CURP (Clave Única de Registro de Población, Mexican personal ID).

    The Clave Única de Registro de Población (Population Registry Code) is unique
    identifier for both citizens and residents of Mexico. The is an 18-character
    alphanumeric that contains certain letters from the person's name, their
    gender and birth date and a check digit.

    More information:
    - https://en.wikipedia.org/wiki/CURP
    - https://www.gob.mx/curp/ *)

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

val get_birth_date : string -> int * int * int
(** Split the date parts from the number and return the birth date (year, month, day). *)

val get_gender : string -> string
(** Get the gender (M/F) from the person's CURP. *)

val calc_check_digit : string -> string
(** Calculate the check digit. *)

val validate : ?validate_check_digits:bool -> string -> string
(** Check if the number is a valid CURP.

    @raise Invalid_format if the number contains invalid characters
    @raise Invalid_length if the length is not 18
    @raise Invalid_checksum if the checksum fails
    @raise Invalid_component if the date, state, blacklist or gender is invalid *)

val is_valid : ?validate_check_digits:bool -> string -> bool
(** Check if the number provided is a valid CURP. *)
