(** ISSN (International Standard Serial Number).

    The ISSN (International Standard Serial Number) is the standard code to
    identify periodical publications (e.g. magazines).

    An ISSN has 8 digits and is formatted in two pairs of 4 digits separated by
    a hyphen. The last digit is a check digit and may be 0-9 or X (similar to
    ISBN-10).

    More information:
    - https://en.wikipedia.org/wiki/International_Standard_Serial_Number
    - https://www.issn.org/ *)

exception Invalid_format
exception Invalid_length
exception Invalid_checksum

val compact : string -> string
(** Convert the ISSN to the minimal representation. This strips the number of
    any valid ISSN separators and removes surrounding whitespace.

    Example: [compact "0032-1478"] returns ["00321478"] *)

val calc_check_digit : string -> string
(** Calculate the ISSN check digit for 8-digit numbers. The number passed should
    not have the check digit included. *)

val validate : string -> string
(** Check if the number is a valid ISSN. This checks the length and whether the
    check digit is correct. Returns the normalized number if valid.

    if the number contains non-digit characters (excluding check digit)
    @raise Invalid_checksum if the checksum validation fails *)

val validate_result : string -> (string, Tools.Error.t) result
(** Same as {!validate} but returns a [result] instead of raising exceptions. *)

val is_valid : string -> bool
(** Check if the number provided is a valid ISSN. Returns [true] if valid,
    [false] otherwise. *)

val format : string -> string
(** Reformat the number to the standard presentation format.

    Example: [format "00249319"] returns ["0024-9319"] *)

val to_ean : ?issue_code:string -> string -> string
(** Convert the number to EAN-13 format.

    Example: [to_ean "0264-3596"] returns ["9770264359008"] *)
