(** Konto nr. (Norwegian bank account number)

    Konto nr. is the country-specific part in Norwegian IBAN codes. The number
    consists of 11 digits, the first 4 are the bank identifier and the last is a
    check digit. This module does not check if the bank identifier exists. *)

exception Invalid_format
exception Invalid_length
exception Invalid_checksum

val compact : string -> string
(** Convert the number to the minimal representation. This strips the
    number of any valid separators and removes surrounding whitespace. *)

val validate : string -> string
(** Check if the number provided is a valid bank account number.
    Raises Invalid_format, Invalid_length, or Invalid_checksum if the number is not valid. *)

val is_valid : string -> bool
(** Check if the number provided is a valid bank account number. *)

val format : string -> string
(** Reformat the number to the standard presentation format (XXXX.XX.XXXXX). *)

val to_iban : string -> string
(** Convert the number to an IBAN. *)
