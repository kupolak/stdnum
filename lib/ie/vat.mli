(** VAT (Irish tax reference number).

    The Irish VAT number consists of 8 or 9 digits. The number is either 7
    digits and 1 letter (optionally followed by a W for married women), 7 digits
    and 2 letters, or 6 digits and 2 letters or symbols (in second and last
    position). *)

exception Invalid_format
exception Invalid_length
exception Invalid_checksum

val compact : string -> string
(** Convert the number to the minimal representation. This strips the number of
    any valid separators and removes surrounding whitespace. *)

val calc_check_digit : string -> string
(** Calculate the check digit. The number passed should not have the check digit
    included. *)

val validate : string -> string
(** Check if the number provided is a valid VAT number. This checks the length,
    formatting and check digit.

    @raise Invalid_checksum if the checksum fails *)

val validate_result : string -> (string, Tools.Error.t) result
(** Same as {!validate} but returns a [result] instead of raising exceptions. *)

val is_valid : string -> bool
(** Check if the number provided is a valid VAT number. *)

val convert : string -> string
(** Convert an "old" style 8-digit VAT number where the second character is a
    letter to the new 8-digit format where only the last digit is a character.
*)
