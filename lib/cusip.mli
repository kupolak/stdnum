(** CUSIP number (financial security identification number).

    CUSIP (Committee on Uniform Securities Identification Procedures) numbers are
    used to identify financial securities. CUSIP numbers are a nine-character
    alphanumeric code where the first six characters identify the issuer,
    followed by two digits that identify the issue, and a check digit.

    More information:
    - https://en.wikipedia.org/wiki/CUSIP
    - https://www.cusip.com/ *)

exception Invalid_format
(** Exception raised when the CUSIP number has invalid format. *)

exception Invalid_length
(** Exception raised when the CUSIP number has invalid length. *)

exception Invalid_checksum
(** Exception raised when the checksum validation fails. *)

val compact : string -> string
(** Convert the number to the minimal representation. This strips the
    number of any valid separators and removes surrounding whitespace.
    Converts to uppercase.

    Example: [compact "dus 0421c5"] returns ["DUS0421C5"] *)

val calc_check_digit : string -> string
(** Calculate the check digit for the number. The passed number should not
    have the check digit included.

    Example: [calc_check_digit "DUS0421C"] returns ["5"] *)

val validate : string -> string
(** Check if the number is valid. This checks the length and checksum.
    Returns the normalized number if valid.

    @raise Invalid_format if the number has invalid format
    @raise Invalid_length if the number has invalid length (not 9 characters)
    @raise Invalid_checksum if the checksum validation fails *)

val is_valid : string -> bool
(** Check if the number is valid.
    Returns [true] if valid, [false] otherwise. *)

val to_isin : string -> string
(** Convert the CUSIP number to an ISIN (with "US" country code).

    Example: [to_isin "91324PAE2"] returns ["US91324PAE25"] *)
