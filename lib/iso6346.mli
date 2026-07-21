(** ISO 6346 (International standard for container identification).

    ISO 6346 is an international standard covering the coding, identification
    and marking of intermodal (shipping) containers used within containerized
    intermodal freight transport. The standard establishes a visual
    identification system for every container that includes a unique serial
    number (with check digit), the owner, a country code, a size, type and
    equipment category as well as any operational marks.

    More information:
    - https://en.wikipedia.org/wiki/ISO_6346

    The number consists of:
    - 3 letters: Owner code
    - 1 letter: Equipment category identifier (U, J, Z, or R)
    - 6 digits: Serial number
    - 1 digit: Check digit *)

exception Invalid_checksum
exception Invalid_length
exception Invalid_format

val compact : string -> string
(** Convert the number to the minimal representation. This strips the number of
    any valid separators and removes surrounding whitespace.

    Example: [compact "tasu117 000 0"] returns ["TASU1170000"] *)

val calc_check_digit : string -> string
(** Calculate check digit and return it for the 10 digit owner code and serial
    number.

    Example: [calc_check_digit "CSQU305438"] returns ["3"] *)

val validate : string -> string
(** Check if the number is a valid ISO 6346 container number. Returns the
    normalized number if valid.

    @raise Invalid_length if the number has an invalid length *)

val validate_result : string -> (string, Tools.Error.t) result
(** Same as {!validate} but returns a [result] instead of raising exceptions. *)

val is_valid : string -> bool
(** Check if the number is a valid ISO 6346 container number. Returns [true] if
    valid, [false] otherwise. *)

val format : string -> string
(** Reformat the number to the standard presentation format.

    Example: [format "TASU1170000"] returns ["TASU 117000 0"] *)
