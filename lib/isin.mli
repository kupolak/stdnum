(** ISIN (International Securities Identification Number).

    The ISIN is a 12-character alpha-numerical code specified in ISO 6166 used to
    identify exchange listed securities such as bonds, commercial paper, stocks
    and warrants. The number is formed of a two-letter country code, a nine
    character national security identifier and a single check digit.

    More information:
    - https://en.wikipedia.org/wiki/International_Securities_Identification_Number *)

exception Invalid_format
(** Exception raised when the ISIN has invalid format. *)

exception Invalid_length
(** Exception raised when the ISIN has invalid length. *)

exception Invalid_component
(** Exception raised when the ISIN has an invalid country code. *)

exception Invalid_checksum
(** Exception raised when the checksum validation fails. *)

val iso_3166_1_country_codes : string list
(** List of all valid ISO 3166-1 alpha-2 country codes. *)

val country_codes : string list
(** List of country codes allowed for ISIN, including special codes. *)

val compact : string -> string
(** Convert the number to the minimal representation. This strips the
    number of any valid separators and removes surrounding whitespace.

    Example: [compact "US 037833 10 05"] returns ["US0378331005"] *)

val calc_check_digit : string -> string
(** Calculate the check digit for the number. The passed number should not
    have the check digit included. *)

val validate : string -> string
(** Check if the number provided is valid. This checks the length and
    check digit. Returns the normalized number if valid.

    @raise Invalid_format if the number contains invalid characters
    @raise Invalid_length if the number has invalid length (not 12 digits)
    @raise Invalid_component if the country code is invalid
    @raise Invalid_checksum if the checksum validation fails *)

val is_valid : string -> bool
(** Check if the number provided is valid.
    Returns [true] if valid, [false] otherwise. *)

val from_natid : string -> string -> string
(** Generate an ISIN from a country code and a national security identifier.

    Example: [from_natid "gb" "BYXJL75"] returns ["GB00BYXJL758"] *)
