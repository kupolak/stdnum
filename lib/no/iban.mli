(** Norwegian IBAN (International Bank Account Number).

    The IBAN is used to identify bank accounts across national borders. The
    Norwegian IBAN is built up of the IBAN prefix (NO) and check digits, followed
    by the 11 digit Konto nr. (bank account number). *)

exception Invalid_component
exception Invalid_length
exception Invalid_format
exception Invalid_checksum

val compact : string -> string
(** Convert the number to the minimal representation. This strips the
    number of any valid separators and removes surrounding whitespace. *)

val format : string -> string
(** Reformat the number to the standard presentation format (groups of 4). *)

val to_kontonr : string -> string
(** Return the Norwegian bank account number part of the IBAN. *)

val validate : string -> string
(** Check if the number provided is a valid Norwegian IBAN.
    Raises Invalid_format, Invalid_length, Invalid_checksum, or Invalid_component
    if the number is not valid. *)

val is_valid : string -> bool
(** Check if the number provided is a valid Norwegian IBAN. *)
