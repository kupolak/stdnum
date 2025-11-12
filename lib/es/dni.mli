(** Spanish DNI (Documento Nacional de Identidad, Spanish personal identity codes).

    The DNI is a 9 digit number used to identify Spanish citizens. The last
    digit is a checksum letter.

    Foreign nationals, since 2010 are issued an NIE (Número de Identificación
    de Extranjeros, Foreigner's Identity Number) instead.
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

    Example: [compact "54362315-K"] returns ["54362315K"] *)

val calc_check_digit : string -> string
(** Calculate the check digit. The number passed should not have the
    check digit included (8 digits).

    Example: [calc_check_digit "54362315"] returns ["K"] *)

val validate : string -> string
(** Check if the number is a valid DNI. This checks the length,
    formatting and check digit. Returns the normalized number if valid.

    @raise Invalid_format if the number has an invalid format
    @raise Invalid_length if the number is not 9 characters
    @raise Invalid_checksum if the check digit is invalid *)

val is_valid : string -> bool
(** Check if the number is a valid DNI.
    Returns [true] if valid, [false] otherwise. *)
