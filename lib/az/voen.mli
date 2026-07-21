(** VÖEN (Vergi ödəyicisinin eyniləşdirmə nömrəsi, Azerbaijan tax number).

    The Vergi ödəyicisinin eyniləşdirmə nömrəsi is issued by the Azerbaijan
    state tax authorities to individuals and legal entities.

    This number consists of 10 digits. The first two digits are the code for the
    territorial administrative unit. The following six digits are a serial
    number. The ninth digit is a check digit. The tenth digit represents the
    legal status of a taxpayer: 1 for legal persons and 2 for natural persons.

    More information:
    - https://www.oecd.org/tax/automatic-exchange/crs-implementation-and-assistance/tax-identification-numbers/Azerbaijan-TIN.pdf
    - https://www.e-taxes.gov.az/ebyn/payerOrVoenChecker.jsp *)

exception Invalid_format
exception Invalid_length
exception Invalid_component
exception Invalid_checksum

val compact : string -> string
(** Convert the number to the minimal representation. This strips the number of
    any valid separators and removes surrounding whitespace. *)

val validate : string -> string
(** Check if the number is a valid Azerbaijan VÖEN number.

    @raise Invalid_checksum if the checksum fails *)

val validate_result : string -> (string, Tools.Error.t) result
(** Same as {!validate} but returns a [result] instead of raising exceptions. *)

val is_valid : string -> bool
(** Check if the number is a valid Azerbaijan VÖEN number. *)
