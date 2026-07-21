(** GRid (Global Release Identifier).

    The Global Release Identifier is used to identify releases of digital sound
    recordings and uses the ISO 7064 Mod 37, 36 algorithm to verify the
    correctness of the number.

    More information:
    - https://en.wikipedia.org/wiki/Global_Release_Identifier *)

exception Invalid_length
exception Invalid_checksum
exception Invalid_format

val compact : string -> string
(** Convert the GRid to the minimal representation. This strips the number of
    any valid separators and removes surrounding whitespace. Also removes
    "GRID:" prefix if present.

    Example: [compact "Grid: A1-2425G-ABC1234002-M"] returns
    ["A12425GABC1234002M"] *)

val validate : string -> string
(** Check if the number is a valid GRid. This checks the length and uses ISO
    7064 Mod 37, 36 algorithm for checksum validation. Returns the normalized
    number if valid.

    @raise Invalid_format if the number has invalid format *)

val validate_result : string -> (string, Tools.Error.t) result
(** Same as {!validate} but returns a [result] instead of raising exceptions. *)

val is_valid : string -> bool
(** Check if the number is valid. Returns [true] if valid, [false] otherwise. *)

val format : ?separator:string -> string -> string
(** Reformat the number to the standard presentation format. Default separator
    is "-".

    Example: [format "A12425GABC1234002M"] returns ["A1-2425G-ABC1234002-M"] *)
