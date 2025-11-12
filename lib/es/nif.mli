(** NIF (Número de Identificación Fiscal, Spanish VAT number).

    The Spanish VAT number is a 9-digit number where either the first, last
    digits or both can be letters.

    The number is either a DNI (Documento Nacional de Identidad, for
    Spaniards), a NIE (Número de Identificación de Extranjero, for
    foreigners) or a CIF (Código de Identificación Fiscal, for legal
    entities and others). *)

exception Invalid_length
exception Invalid_format
exception Invalid_checksum

val compact : string -> string
(** Convert the number to the minimal representation. This strips the
    number of any valid separators and removes surrounding whitespace. *)

val validate : string -> string
(** Check if the number provided is a valid VAT number. This checks the
    length, formatting and check digit. Returns the compacted number if valid,
    raises an exception otherwise. *)

val is_valid : string -> bool
(** Check if the number provided is a valid VAT number. Returns true if valid,
    false otherwise. *)
