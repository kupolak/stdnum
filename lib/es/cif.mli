(** Spanish CIF (Código de Identificación Fiscal, Spanish company tax number).

    The CIF is a tax identification number for legal entities. It has 9 digits
    where the first digit is a letter (denoting the type of entity) and the
    last is a check digit (which may also be a letter).

    More information:
    - https://es.wikipedia.org/wiki/Código_de_identificación_fiscal
*)

exception Invalid_length
(** Exception raised when the number has an invalid length (not 9 characters). *)

exception Invalid_format
(** Exception raised when the number has an invalid format. *)

exception Invalid_checksum
(** Exception raised when the check digit is invalid. *)

val compact : string -> string
(** Convert the number to the minimal representation. This strips the
    number of any valid separators and removes surrounding whitespace.

    Example: [compact "A13 585 625"] returns ["A13585625"] *)

val calc_check_digits : string -> string
(** Calculate the check digits for the specified number. The number
    passed should not have the check digit included. This function returns
    both the number and character check digit candidates as a string.

    Example: [calc_check_digits "J9921658"] returns ["2B"] *)

val validate : string -> string
(** Check if the number is a valid CIF. This checks the length,
    formatting and check digit. Returns the normalized number if valid.

    @raise Invalid_format if the number has an invalid format
    @raise Invalid_length if the number is not 9 characters
    @raise Invalid_checksum if the check digit is invalid *)

val is_valid : string -> bool
(** Check if the number is a valid CIF.
    Returns [true] if valid, [false] otherwise. *)

val split : string -> string * string * string * string
(** Split the provided number into a letter to define the type of
    organisation, two digits that specify a province, a 5 digit sequence
    number within the province and a check digit.

    Example: [split "A13585625"] returns [("A", "13", "58562", "5")] *)
