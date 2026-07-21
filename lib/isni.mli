(** ISNI (International Standard Name Identifier).

    The International Standard Name Identifier (ISNI) is used to identify
    contributors to media content such as books, television programmes, and
    newspaper articles. The number consists of 16 digits where the last
    character is a check digit.

    More information:
    - https://en.wikipedia.org/wiki/International_Standard_Name_Identifier
    - https://isni.org/ *)

exception Invalid_format
exception Invalid_length
exception Invalid_checksum

val compact : string -> string
(** Convert the ISNI to the minimal representation. This strips the number of
    any valid ISNI separators and removes surrounding whitespace. *)

val validate : string -> string
(** Check if the number is a valid ISNI. This checks the length and whether the
    check digit is correct.

    @raise Invalid_checksum if the checksum fails *)

val validate_result : string -> (string, Tools.Error.t) result
(** Same as {!validate} but returns a [result] instead of raising exceptions. *)

val is_valid : string -> bool
(** Check if the number provided is a valid ISNI. *)

val format : string -> string
(** Reformat the number to the standard presentation format. *)
