(** ABN (Australian Business Number).

    The Australian Business Number (ABN) is an identifier issued to entities
    registered in the Australian Business Register (ABR). The number consists of
    11 digits of which the first two are check digits.

    More information:
    - https://en.wikipedia.org/wiki/Australian_Business_Number
    - https://abr.business.gov.au/ *)

exception Invalid_format
exception Invalid_length
exception Invalid_checksum

val compact : string -> string
(** Convert the number to the minimal representation. This strips the number of
    any valid separators and removes surrounding whitespace. *)

val calc_check_digits : string -> string
(** Calculate the check digits that should be prepended to make the number
    valid. *)

val validate : string -> string
(** Check if the number is a valid ABN. This checks the length, formatting and
    check digit.

    @raise Invalid_checksum if the checksum fails *)

val validate_result : string -> (string, Tools.Error.t) result
(** Same as {!validate} but returns a [result] instead of raising exceptions. *)

val is_valid : string -> bool
(** Check if the number is a valid ABN. *)

val format : string -> string
(** Reformat the number to the standard presentation format. *)
