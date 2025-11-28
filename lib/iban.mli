(** IBAN (International Bank Account Number).

    The IBAN is used to identify bank accounts across national borders. The
    first two letters are a country code. The next two digits are check digits
    for the ISO 7064 Mod 97, 10 checksum. Each country uses its own format
    for the remainder of the number.

    More information:
    - https://en.wikipedia.org/wiki/International_Bank_Account_Number
    - https://www.swift.com/products_services/bic_and_iban_format_registration_iban_format_r
*)

exception Invalid_component
(** Exception raised when the number has an invalid component (e.g., wrong country, invalid BBAN structure). *)

exception Invalid_checksum
(** Exception raised when the check digits are invalid. *)

exception Invalid_length
(** Exception raised when the number has an invalid length. *)

exception Invalid_format
(** Exception raised when the number has an invalid format. *)

val compact : string -> string
(** Convert the IBAN number to the minimal representation. This strips the
    number of any valid separators and removes surrounding whitespace.

    Example: [compact "GR16 0110 1050 0000 1054 7023 795"] returns ["GR1601101050000010547023795"] *)

val calc_check_digits : string -> string
(** Calculate the check digits that should be put in the number to make
    it valid. Check digits in the supplied number are ignored.

    Example: [calc_check_digits "BExx435411161155"] returns ["31"] *)

val validate : ?check_country:bool -> string -> string
(** Check if the number provided is a valid IBAN. Returns the normalized number if valid.
    The country-specific check can be disabled with the [check_country] argument (default: true).

    @raise Invalid_component if the country code is invalid or BBAN structure is invalid
    @raise Invalid_checksum if the check digits are invalid
    @raise Invalid_format if the number has an invalid format
    @raise Invalid_length if the number has an invalid length *)

val is_valid : ?check_country:bool -> string -> bool
(** Check if the number provided is a valid IBAN.
    Returns [true] if valid, [false] otherwise. *)

val format : ?separator:string -> string -> string
(** Reformat the passed number to the space-separated format.
    The default separator is a space, but can be customized.

    Example: [format "GR1601101050000010547023795"] returns ["GR16 0110 1050 0000 1054 7023 795"] *)
