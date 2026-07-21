(** Spanish IBAN (International Bank Account Number).

    The IBAN is used to identify bank accounts across national borders. The
    Spanish IBAN is built up of the IBAN prefix (ES) and check digits, followed
    by the 20 digit CCC (Código Cuenta Corriente). *)

exception Invalid_component
exception Invalid_checksum
exception Invalid_length
exception Invalid_format

(** Exception raised when the number has an invalid component (e.g., wrong
    country). *)

val compact : string -> string
(** Convert the number to the minimal representation. This strips the number of
    any valid separators and removes surrounding whitespace.

    Example: [compact "ES77 1234-1234-16 1234567890"] returns
    ["ES7712341234161234567890"] *)

val format : string -> string
(** Reformat the number to the standard IBAN presentation format.

    Example: [format "ES7712341234161234567890"] returns
    ["ES77 1234 1234 1612 3456 7890"] *)

val to_ccc : string -> string
(** Return the CCC (Código Cuenta Corriente) part of the number.

    Example: [to_ccc "ES77 1234-1234-16 1234567890"] returns
    ["12341234161234567890"] *)

val validate : string -> string
(** Check if the number is a valid Spanish IBAN. This validates both the IBAN
    check digits and the CCC check digits. Returns the normalized number if
    valid.

    @raise Invalid_length if the number has an invalid length *)

val validate_result : string -> (string, Tools.Error.t) result
(** Same as {!validate} but returns a [result] instead of raising exceptions. *)

val is_valid : string -> bool
(** Check if the number is a valid Spanish IBAN. Returns [true] if valid,
    [false] otherwise. *)
