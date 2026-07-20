(** PNF (ЛНЧ, Личен номер на чужденец, Bulgarian number of a foreigner).

    The personal number of a foreigner is a 10-digit number where the last digit
    is the result of a weighted checksum. *)

exception Invalid_format
(** Exception raised when the PNF has invalid format. *)

exception Invalid_length
(** Exception raised when the PNF has invalid length. *)

exception Invalid_checksum
(** Exception raised when the checksum validation fails. *)

val compact : string -> string
(** Convert the number to the minimal representation. This strips the
    number of any valid separators and removes surrounding whitespace. *)

val calc_check_digit : string -> string
(** Calculate the check digit. The number passed should not have the
    check digit included. *)

val validate : string -> string
(** Check if the number is a valid national identification number. This
    checks the length, formatting, and check digit.

    @raise Invalid_format if the number contains invalid characters
    @raise Invalid_length if the length is not 10
    @raise Invalid_checksum if the checksum fails *)

val is_valid : string -> bool
(** Check if the number is a valid national identification number. *)
