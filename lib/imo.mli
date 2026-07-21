(** IMO number (International Maritime Organization number).

    A number used to uniquely identify ships (the hull) for purposes of
    registering owners and management companies. The ship identification number
    consists of a six-digit sequentially assigned number and a check digit. The
    number is usually prefixed with "IMO".

    More information:
    - https://en.wikipedia.org/wiki/IMO_number *)

exception Invalid_format
exception Invalid_length
exception Invalid_checksum

val compact : string -> string
(** Convert the number to the minimal representation. This strips the number of
    any valid separators, removes the "IMO" prefix and surrounding whitespace.

    Example: [compact "IMO 9319466"] returns ["9319466"] *)

val calc_check_digit : string -> string
(** Calculate the check digit for the number. The passed number should not have
    the check digit included.

    Example: [calc_check_digit "931946"] returns ["6"] *)

val validate : string -> string
(** Check if the number provided is valid. This checks the length, format and
    check digit. Returns the normalized number if valid.

    @raise Invalid_checksum if the checksum validation fails *)

val validate_result : string -> (string, Tools.Error.t) result
(** Same as {!validate} but returns a [result] instead of raising exceptions. *)

val is_valid : string -> bool
(** Check if the number provided is valid. Returns [true] if valid, [false]
    otherwise. *)

val format : string -> string
(** Reformat the number to the standard presentation format.

    Example: [format "9319466"] returns ["IMO 9319466"] *)
