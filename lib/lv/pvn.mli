(** PVN (Pievienotās vērtības nodokļa, Latvian VAT number).

    The PVN is a 11-digit number that can either be a reference to a legal
    entity (in which case the first digit > 3) or a natural person (in which
    case it should be the same as the personal code (personas kods)). Personal
    codes start "32". Older personal codes start with 6 digits to denote the
    birth date in the form ddmmyy.

    More information:
    - https://en.wikipedia.org/wiki/National_identification_number#Latvia *)

exception Invalid_format
exception Invalid_length
exception Invalid_component
exception Invalid_checksum

val compact : string -> string
(** Convert the number to the minimal representation. This strips the number of
    any valid separators and removes surrounding whitespace. *)

val checksum : string -> int
(** Calculate the checksum for legal entities. *)

val calc_check_digit_pers : string -> string
(** Calculate the check digit for personal codes. The number passed should not
    have the check digit included. *)

val get_birth_date : string -> int * int * int
(** Split the date parts from the number and return the birth date. *)

val validate : string -> string
(** Check if the number is a valid VAT number. This checks the length,
    formatting and check digit.

    @raise Invalid_checksum if the checksum fails *)

val validate_result : string -> (string, Tools.Error.t) result
(** Same as {!validate} but returns a [result] instead of raising exceptions. *)

val is_valid : string -> bool
(** Check if the number is a valid VAT number. *)
