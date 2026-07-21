(** VAT (European Union VAT number).

    The European Union VAT number consists of a 2 letter country code (ISO
    3166-1, except Greece which uses EL) followed by a number that is
    allocated per country.

    The exact format of the numbers varies per country.
    In this OCaml port, without dynamic module loading, we perform a basic
    prefix and format check.

    More information:
    - https://en.wikipedia.org/wiki/VAT_identification_number *)

exception Invalid_format
(** Exception raised when the number has invalid format. *)

exception Invalid_length
(** Exception raised when the number has invalid length. *)

exception Invalid_component
(** Exception raised when the country code component is invalid. *)

val compact : string -> string
(** Convert the number to the minimal representation. This strips the
    number of any valid separators and removes surrounding whitespace. *)

val validate : string -> string
(** Check if the number is a valid VAT number. This performs the
    country-specific check for the number.

    @raise Invalid_format if the number contains invalid characters
    @raise Invalid_length if the length is too short
    @raise Invalid_component if the country code is invalid *)

val is_valid : string -> bool
(** Check if the number is a valid VAT number. *)

val guess_country : string -> string list
(** Guess the country code based on the number. Returns lower case codes
    and returns gr (not el) for Greece. *)
