(** PVM (Pridėtinės vertės mokestis mokėtojo kodas, Lithuanian VAT number).

    The PVM is used for VAT purposes in Lithuania. It is 9 digits (for legal
    entities) or 12 digits long (for temporarily registered taxpayers). This
    module does not check the format of Lithuanian personal codes (Asmens
    kodas). *)

exception Invalid_format
(** Exception raised when the number has invalid format. *)

exception Invalid_length
(** Exception raised when the number has invalid length. *)

exception Invalid_component
(** Exception raised when a component of the number is invalid. *)

exception Invalid_checksum
(** Exception raised when the checksum validation fails. *)

val compact : string -> string
(** Convert the number to the minimal representation. This strips the
    number of any valid separators and removes surrounding whitespace. *)

val calc_check_digit : string -> string
(** Calculate the check digit. The number passed should not have the
    check digit included. *)

val validate : string -> string
(** Check if the number is a valid VAT number. This checks the length,
    formatting and check digit.

    @raise Invalid_format if the number contains invalid characters
    @raise Invalid_length if the length is not 9 or 12
    @raise Invalid_component if the 8th or 11th digit is not 1
    @raise Invalid_checksum if the checksum fails *)

val is_valid : string -> bool
(** Check if the number is a valid VAT number. *)
