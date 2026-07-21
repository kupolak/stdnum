(** UID (Umsatzsteuer-Identifikationsnummer, Austrian VAT number).

    The Austrian UID is a 9-digit number that starts with a U (optionally
    preceded with AT). The last digit is a check digit.

    More information:
    - https://en.wikipedia.org/wiki/VAT_identification_number *)

exception Invalid_format
(** Exception raised when the UID has invalid format. *)

exception Invalid_length
(** Exception raised when the UID has invalid length. *)

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
    formatting and check digit.

    @raise Invalid_format if the number contains invalid characters
    @raise Invalid_length if the length is not 9
    @raise Invalid_checksum if the checksum fails *)

val is_valid : string -> bool
(** Check if the number is a valid VAT number. *)
