(** Montenegro IBAN (International Bank Account Number).

    The IBAN is used to identify bank accounts across national borders. The
    Montenegro IBAN is built up of the IBAN prefix (ME) and check digits,
    followed by a 3 digit bank identifier, a 13 digit account number and 2 more
    check digits. *)

exception Invalid_format
(** Exception raised when the number has invalid format. *)

exception Invalid_length
(** Exception raised when the number has invalid length. *)

exception Invalid_checksum
(** Exception raised when the checksum validation fails. *)

exception Invalid_component
(** Exception raised when a component of the number is invalid. *)

val compact : string -> string
(** Convert the Montenegro IBAN to the minimal representation. *)

val format : string -> string
(** Reformat the number to the standard presentation format. *)

val validate : string -> string
(** Check if the number provided is a valid Montenegro IBAN. *)

val is_valid : string -> bool
(** Check if the number provided is a valid Montenegro IBAN. *)
