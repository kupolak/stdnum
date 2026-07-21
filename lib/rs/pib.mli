(** PIB (Poreski Identifikacioni Broj, Serbian tax identification number).

    The Serbian tax identification number consists of 9 digits where the last
    digit is a check digit. *)

exception Invalid_format
(** Exception raised when the number has invalid format. *)

exception Invalid_length
(** Exception raised when the number has invalid length. *)

exception Invalid_checksum
(** Exception raised when the checksum validation fails. *)

val compact : string -> string
(** Convert the number to the minimal representation. This strips the
    number of any valid separators and removes surrounding whitespace. *)

val validate : string -> string
(** Check if the number is a valid VAT number. This checks the length,
    formatting and check digit. *)

val is_valid : string -> bool
(** Check if the number is a valid VAT number. *)
