(** PIN (Personal Identification Number, Kenya tax number).

    The Personal Identification Number (KRA PIN) is an 11 digit unique number that
    is issued by Kenya Revenue Authority (KRA) for purposes of transacting business
    with KRA, other Government agencies and service providers. It can be issued for
    individuals and non-individuals like companies, schools, organisations, etc.

    The number consists of 11 characters, where the first one is an A (for
    individuals) or a P (for non-individuals), the last one is a letter, and the
    rest are digits.

    More information:
    - https://www.kra.go.ke/individual/individual-pin-registration/learn-about-pin/about-pin
    - https://itax.kra.go.ke/KRA-Portal/pinChecker.htm *)

exception Invalid_format
(** Exception raised when the number has invalid format. *)

exception Invalid_length
(** Exception raised when the number has invalid length. *)

val compact : string -> string
(** Convert the number to the minimal representation. This strips the
    number of any valid separators and removes surrounding whitespace. *)

val validate : string -> string
(** Check if the number is a valid Kenya PIN number.

    This checks the length and formatting.

    @raise Invalid_format if the number contains invalid characters
    @raise Invalid_length if the length is not 11 *)

val is_valid : string -> bool
(** Check if the number is a valid Kenya PIN number. *)

val format : string -> string
(** Reformat the number to the standard presentation format. *)
