(** Spanish CCC (Código Cuenta Corriente, Spanish Bank Account Code).

    The CCC code is the country-specific part in Spanish IBAN codes. In order to
    fully validate a Spanish IBAN you have to validate as well the country
    specific part as a valid CCC. It was used for home banking transactions until
    February 1st 2014 when IBAN codes started to be used as an account ID.

    The CCC has 20 digits, all being numbers: EEEE OOOO DD NNNNNNNNNN

    - EEEE: banking entity
    - OOOO: office
    - DD: check digits
    - NNNNNNNNNN: account identifier

    This module does not check if the bank code exists. Existing bank codes are
    published on the 'Registro de Entidades' by 'Banco de España' (Spanish
    Central Bank).

    More information:
    - https://es.wikipedia.org/wiki/Código_cuenta_cliente
    - https://www.bde.es/bde/es/secciones/servicios/Particulares_y_e/Registros_de_Ent/
*)

exception Invalid_length
(** Exception raised when the number has an invalid length (not 20 digits). *)

exception Invalid_format
(** Exception raised when the number contains non-digit characters. *)

exception Invalid_checksum
(** Exception raised when the check digits are invalid. *)

val compact : string -> string
(** Convert the number to the minimal representation. This strips the
    number of any valid separators and removes surrounding whitespace.

    Example: [compact "1234-1234-16 1234567890"] returns ["12341234161234567890"] *)

val calc_check_digits : string -> string
(** Calculate the check digits for the number. The supplied number should
    have check digits included but are ignored.

    Example: [calc_check_digits "12341234001234567890"] returns ["16"] *)

val validate : string -> string
(** Check if the number is a valid CCC. This checks the length,
    formatting and check digits. Returns the normalized number if valid.

    @raise Invalid_format if the number contains non-digit characters
    @raise Invalid_length if the number is not 20 digits
    @raise Invalid_checksum if the check digits are invalid *)

val is_valid : string -> bool
(** Check if the number is a valid CCC.
    Returns [true] if valid, [false] otherwise. *)

val format : string -> string
(** Reformat the number to the standard presentation format (EEEE OOOO DD NNNNN NNNNN).

    Example: [format "12341234161234567890"] returns ["1234 1234 16 12345 67890"] *)

val to_iban : string -> string
(** Convert the number to an IBAN.

    Example: [to_iban "21000418450200051331"] returns ["ES2121000418450200051331"] *)
