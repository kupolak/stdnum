(** FIGI (Financial Instrument Global Identifier).

    The Financial Instrument Global Identifier (FIGI) is a 12-character
    alpha-numerical unique identifier of financial instruments such as common
    stock, options, derivatives, futures, corporate and government bonds,
    municipals, currencies, and mortgage products.

    More information:
    - https://openfigi.com/
    - https://en.wikipedia.org/wiki/Financial_Instrument_Global_Identifier *)

exception Invalid_format
exception Invalid_length
exception Invalid_checksum
exception Invalid_component

val compact : string -> string
(** Convert the number to the minimal representation. This strips the number of
    any valid separators and removes surrounding whitespace. Converts to
    uppercase.

    Example: [compact "bbg 000 blnq16"] returns ["BBG000BLNQ16"] *)

val calc_check_digit : string -> string
(** Calculate the check digit for the number. The passed number should not have
    the check digit included.

    Example: [calc_check_digit "BBG000BLNQ1"] returns ["6"] *)

val validate : string -> string
(** Check if the number is valid. This checks the length, format, and checksum.
    Returns the normalized number if valid.

    @raise Invalid_component if a component is invalid *)

val validate_result : string -> (string, Tools.Error.t) result
(** Same as {!validate} but returns a [result] instead of raising exceptions. *)

val is_valid : string -> bool
(** Check if the number is valid. Returns [true] if valid, [false] otherwise. *)
