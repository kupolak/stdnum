(** ISRC (International Standard Recording Code).

    The ISRC is an international standard code (ISO 3901) for uniquely
    identifying sound recordings and music video recordings.

    More information:
    - https://en.wikipedia.org/wiki/International_Standard_Recording_Code *)

exception Invalid_format
(** Exception raised when the ISRC has invalid format. *)

exception Invalid_length
(** Exception raised when the ISRC has invalid length. *)

exception Invalid_component
(** Exception raised when the ISRC has an invalid country code. *)

val compact : string -> string
(** Convert the ISRC to the minimal representation. This strips the
    number of any valid separators and removes surrounding whitespace.

    Example: [compact "US-SKG-19-12345"] returns ["USSKG1912345"] *)

val validate : string -> string
(** Check if the number provided is a valid ISRC. This checks the length,
    the alphabet, and the country code but does not check if the registrant
    code is known. Returns the normalized number if valid.

    @raise Invalid_format if the number contains invalid characters
    @raise Invalid_length if the number has invalid length (not 12 characters)
    @raise Invalid_component if the country code is invalid *)

val is_valid : string -> bool
(** Check if the number provided is a valid ISRC.
    Returns [true] if valid, [false] otherwise. *)

val format : ?separator:string -> string -> string
(** Reformat the number to the standard presentation format.

    Example: [format "USSKG1912345"] returns ["US-SKG-19-12345"] *)
