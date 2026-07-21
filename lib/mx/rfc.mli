(** RFC (Registro Federal de Contribuyentes, Mexican tax number).

    This number is used to identify individuals and companies for tax purposes.

    The company number is 12 digits where the first 3 letters or digits are
    derived from the name of the company, the following 6 contain the date of
    incorporation, followed by 3 check digits.

    Personal numbers consist of 13 digits where the first 4 characters from the
    person's name, followed by their birth date and 3 check digits.

    The first two check digits are calculated based on the person's or company's
    full name. The last check digit is calculated over all the preceding digits
    in the number. However, it seems a lot of numbers (estimated at around 1.5%
    of all numbers) are in use with invalid check digits so this test is disabled
    by default.

    More information:
    - https://www.infomex.org.mx/jspsi/documentos/2005/seguimiento/06101/0610100162005_065.doc
    - https://es.wikipedia.org/wiki/Registro_Federal_de_Contribuyentes_(M%C3%A9xico) *)

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
(** Calculate the check digit. The number passed should not have the
    check digit included. *)

val validate : ?validate_check_digits:bool -> string -> string
(** Check if the number is a valid RFC.

    @raise Invalid_format if the number contains invalid characters
    @raise Invalid_length if the length is not 12 or 13
    @raise Invalid_checksum if the checksum fails
    @raise Invalid_component if the date, blacklist or check digits structure is invalid *)

val is_valid : ?validate_check_digits:bool -> string -> bool
(** Check if the number provided is a valid RFC. *)

val format : ?separator:string -> string -> string
(** Reformat the number to the standard presentation format. *)
