(** Montenegro IBAN (International Bank Account Number).

    The IBAN is used to identify bank accounts across national borders. The
    Montenegro IBAN is built up of the IBAN prefix (ME) and check digits,
    followed by a 3 digit bank identifier, a 13 digit account number and 2 more
    check digits. *)

exception Invalid_format
exception Invalid_length
exception Invalid_checksum
exception Invalid_component

val compact : string -> string
(** Convert the Montenegro IBAN to the minimal representation. *)

val format : string -> string
(** Reformat the number to the standard presentation format. *)

val validate : string -> string
(** Check if the number provided is a valid Montenegro IBAN. *)

val validate_result : string -> (string, Tools.Error.t) result
(** Same as {!validate} but returns a [result] instead of raising exceptions. *)

val is_valid : string -> bool
(** Check if the number provided is a valid Montenegro IBAN. *)
