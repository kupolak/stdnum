(** Spanish CUPS (Código Unificado de Punto de Suministro, Spanish meter point number).

    CUPS codes are used in Spain as unique identifier for energy supply points.
    They are used both for electricity and pipelined gas.

    The format is set by the Energy Ministry, and individual codes are issued by
    each local distribution company. The number consist or 20 or 22 digits and is
    built up as follows:

    - LL: (letters) country (always 'ES' since it is a national code)
    - DDDD: (numbers) distribution company code (numeric)
    - CCCC CCCC CCCC: identifier within the distribution company (numeric)
    - EE: (letters) check digits
    - N: (number) border point sequence
    - T: (letter) kind of border point

    More information:
    - https://es.wikipedia.org/wiki/Código_Unificado_de_Punto_de_Suministro
*)

exception Invalid_length
(** Exception raised when the number has an invalid length (not 20 or 22 characters). *)

exception Invalid_format
(** Exception raised when the number has an invalid format. *)

exception Invalid_checksum
(** Exception raised when the check digits are invalid. *)

exception Invalid_component
(** Exception raised when the country code is not 'ES'. *)

val compact : string -> string
(** Convert the number to the minimal representation. This strips the
    number of any valid separators and removes surrounding whitespace.

    Example: [compact "ES 1234-123456789012-JY"] returns ["ES1234123456789012JY"] *)

val format : string -> string
(** Reformat the number to the standard presentation format.

    Example: [format "ES1234123456789012JY1F"] returns ["ES 1234 1234 5678 9012 JY 1F"] *)

val calc_check_digits : string -> string
(** Calculate the check digits for the number.

    Example: [calc_check_digits "ES1234123456789012"] returns ["JY"] *)

val validate : string -> string
(** Check if the number is a valid CUPS. This checks length,
    formatting and check digits. Returns the normalized number if valid.

    @raise Invalid_format if the number has an invalid format
    @raise Invalid_length if the number is not 20 or 22 characters
    @raise Invalid_checksum if the check digits are invalid
    @raise Invalid_component if the country code is not 'ES' *)

val is_valid : string -> bool
(** Check if the number is a valid CUPS.
    Returns [true] if valid, [false] otherwise. *)
