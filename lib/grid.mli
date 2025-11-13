(** GRid (Global Release Identifier).

    The Global Release Identifier is used to identify releases of digital
    sound recordings and uses the ISO 7064 Mod 37, 36 algorithm to verify the
    correctness of the number.

    More information:
    - https://en.wikipedia.org/wiki/Global_Release_Identifier *)

exception Invalid_length
(** Exception raised when the GRid has invalid length. *)

exception Invalid_checksum
(** Exception raised when the checksum validation fails. *)

exception Invalid_format
(** Exception raised when the GRid has invalid format. *)

val compact : string -> string
(** Convert the GRid to the minimal representation. This strips the
    number of any valid separators and removes surrounding whitespace.
    Also removes "GRID:" prefix if present.

    Example: [compact "Grid: A1-2425G-ABC1234002-M"] returns ["A12425GABC1234002M"] *)

val validate : string -> string
(** Check if the number is a valid GRid. This checks the length and
    uses ISO 7064 Mod 37, 36 algorithm for checksum validation.
    Returns the normalized number if valid.

    @raise Invalid_length if the number has invalid length (not 18 characters)
    @raise Invalid_checksum if the checksum validation fails
    @raise Invalid_format if the number has invalid format *)

val is_valid : string -> bool
(** Check if the number is valid.
    Returns [true] if valid, [false] otherwise. *)

val format : ?separator:string -> string -> string
(** Reformat the number to the standard presentation format.
    Default separator is "-".

    Example: [format "A12425GABC1234002M"] returns ["A1-2425G-ABC1234002-M"] *)
