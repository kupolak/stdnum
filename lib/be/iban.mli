(** Belgian IBAN (International Bank Account Number).

    The IBAN is used to identify bank accounts across national borders. The
    Belgian IBAN is built up of the IBAN prefix (BE) and check digits, followed
    by a 3 digit bank identifier, a 7 digit account number and 2 more check
    digits. *)

exception Invalid_length
exception Invalid_format
exception Invalid_checksum
exception Invalid_component

val compact : string -> string
(** Convert the number to the minimal representation. This strips the
    number of any valid separators and removes surrounding whitespace. *)

val format : string -> string
(** Reformat the number to the standard IBAN presentation format. *)

val validate : string -> string
(** Check if the number provided is a valid Belgian IBAN. Returns the compacted
    number if valid, raises an exception otherwise. *)

val is_valid : string -> bool
(** Check if the number provided is a valid Belgian IBAN. Returns true if valid,
    false otherwise. *)

val to_bic : string -> string option
(** Return the BIC for the bank that this number refers to, or None if unknown. *)
