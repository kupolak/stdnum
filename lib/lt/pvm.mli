(** PVM (Pridėtinės vertės mokestis mokėtojo kodas, Lithuanian VAT number).

    The PVM is used for VAT purposes in Lithuania. It is 9 digits (for legal
    entities) or 12 digits long (for temporarily registered taxpayers). This
    module does not check the format of Lithuanian personal codes (Asmens
    kodas). *)

exception Invalid_format
exception Invalid_length
exception Invalid_component
exception Invalid_checksum

val compact : string -> string
(** Convert the number to the minimal representation. This strips the number of
    any valid separators and removes surrounding whitespace. *)

val calc_check_digit : string -> string
(** Calculate the check digit. The number passed should not have the check digit
    included. *)

val validate : string -> string
(** Check if the number is a valid VAT number. This checks the length,
    formatting and check digit.

    @raise Invalid_checksum if the checksum fails *)

val validate_result : string -> (string, Tools.Error.t) result
(** Same as {!validate} but returns a [result] instead of raising exceptions. *)

val is_valid : string -> bool
(** Check if the number is a valid VAT number. *)
