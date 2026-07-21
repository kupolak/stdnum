(** ISMN (International Standard Music Number).

    The ISMN (International Standard Music Number) is used to identify sheet
    music. This module handles both numbers in the 10-digit 13-digit format.

    More information:
    - https://en.wikipedia.org/wiki/International_Standard_Music_Number *)

exception Invalid_format
exception Invalid_length
exception Invalid_component
exception Invalid_checksum

(** Exception raised when the ISMN contains an invalid component (e.g. wrong
    prefix). *)

val compact : string -> string
(** Convert the ISMN to the minimal representation. This strips the number of
    any valid ISMN separators and removes surrounding whitespace. *)

val validate : string -> string
(** Check if the number provided is a valid ISMN (either a legacy 10-digit one
    or a 13-digit one). This checks the length and the check bit but does not
    check if the publisher is known.

    @raise Invalid_checksum if the checksum fails *)

val validate_result : string -> (string, Tools.Error.t) result
(** Same as {!validate} but returns a [result] instead of raising exceptions. *)

val ismn_type : string -> string option
(** Check the type of ISMN number passed and return [Some "ISMN13"],
    [Some "ISMN10"] or [None] (for invalid). *)

val is_valid : string -> bool
(** Check if the number provided is a valid ISMN. *)

val to_ismn13 : string -> string
(** Convert the number to ISMN13 (EAN) format. *)

val split : string -> string * string * string * string * string
(** Split the specified ISMN into a bookland prefix (979), an ISMN prefix (0), a
    publisher element (3 to 7 digits), an item element (2 to 6 digits) and a
    check digit. *)

val format : ?separator:string -> string -> string
(** Reformat the number to the standard presentation format with the prefixes,
    the publisher element, the item element and the check-digit separated by the
    specified separator. The number is converted to the 13-digit format
    silently. *)
