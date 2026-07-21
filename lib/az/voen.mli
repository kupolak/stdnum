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
(** Exception raised when the VOEN has invalid format. *)

exception Invalid_length
(** Exception raised when the VOEN has invalid length. *)

exception Invalid_component
(** Exception raised when the VOEN has invalid legal status indicator. *)

exception Invalid_checksum
(** Exception raised when the checksum validation fails. *)

val compact : string -> string
(** Convert the number to the minimal representation. This strips the number of
    any valid separators and removes surrounding whitespace. *)

val validate : string -> string
(** Check if the number is a valid Azerbaijan VÖEN number.

    @raise Invalid_format if the number contains invalid characters
    @raise Invalid_length if the length is not 10
    @raise Invalid_component if the last digit is not 1 or 2
    @raise Invalid_checksum if the checksum fails *)

val is_valid : string -> bool
(** Check if the number is a valid Azerbaijan VÖEN number. *)
