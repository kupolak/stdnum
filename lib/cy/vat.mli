(** Αριθμός Εγγραφής Φ.Π.Α. (Cypriot VAT number).

    The Cypriot Αριθμός Εγγραφής Φ.Π.Α. (VAT) number consists of 9 digits
    where the last one is a is a letter and functions as a check digit. *)

exception Invalid_format
(** Exception raised when the VAT has invalid format. *)

exception Invalid_length
(** Exception raised when the VAT has invalid length. *)

exception Invalid_component
(** Exception raised when the VAT has an invalid component (e.g. starts with 12). *)

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
    @raise Invalid_length if the length is not 9
    @raise Invalid_component if the number starts with 12
    @raise Invalid_checksum if the checksum fails *)

val is_valid : string -> bool
(** Check if the number is a valid VAT number. *)
