(** NIF (Número de identificação fiscal, Portuguese VAT number).

    The NIF (Número de identificação fiscal, NIPC, Número de Identificação de
    Pessoa Colectiva) is used for VAT purposes. It is a 9-digit number with a
    simple checksum. *)

exception Invalid_format
(** Exception raised when the number has invalid format. *)

exception Invalid_length
(** Exception raised when the number has invalid length. *)

exception Invalid_checksum
(** Exception raised when the checksum validation fails. *)

val compact : string -> string
(** Convert the number to the minimal representation. This strips the number of
    any valid separators and removes surrounding whitespace. *)

val calc_check_digit : string -> string
(** Calculate the check digit. The number passed should not have the check digit
    included. *)

val validate : string -> string
(** Check if the number is a valid VAT number. This checks the length,
    formatting and check digit. *)

val is_valid : string -> bool
(** Check if the number is a valid VAT number. *)
