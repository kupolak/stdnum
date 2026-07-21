(** SEPA Identifier of the Creditor (AT-02).

    This identifier is indicated in the ISO 20022 data element `Creditor Scheme
    Identification`. The creditor can be a legal entity, or an association that
    is not a legal entity, or a person.

    The first two digits contain the ISO country code, the next two are check
    digits for the ISO 7064 Mod 97, 10 checksum, the next tree contain the
    Creditor Business Code (or `ZZZ` if no business code used) and the remainder
    contains the country-specific identifier. *)

exception Invalid_format
(** Exception raised when the identifier has invalid format. *)

exception Invalid_checksum
(** Exception raised when the checksum validation fails. *)

val compact : string -> string
(** Convert the AT-02 number to the minimal representation. This strips the
    number of any valid separators and removes invalid characters. *)

val validate : string -> string
(** Check if the number provided is a valid AT-02.

    @raise Invalid_format if the number contains invalid characters
    @raise Invalid_checksum if the checksum fails *)

val is_valid : string -> bool
(** Check if the number provided is a valid AT-02. *)

val calc_check_digits : string -> string
(** Calculate the check digits that should be put in the number to make it
    valid. Check digits in the supplied number are ignored. *)
