(** Kennitala (Icelandic personal and organisation identity code).

    Module for handling Icelandic personal and organisation identity codes
    (kennitala). *)

exception Invalid_format
exception Invalid_component
exception Invalid_checksum

val compact : string -> string
(** Convert the kennitala to the minimal representation. This strips surrounding
    whitespace and separation dash, and converts it to upper case. *)

val validate : string -> string
(** Check if the number provided is a valid kennitala. It checks the format,
    whether a valid date is given and whether the check digit is correct.

    @raise Invalid_checksum if the checksum fails *)

val validate_result : string -> (string, Tools.Error.t) result
(** Same as {!validate} but returns a [result] instead of raising exceptions. *)

val is_valid : string -> bool
(** Check if the number provided is a valid HETU. It checks the format, whether
    a valid date is given and whether the check digit is correct. *)

val format : string -> string
(** Reformat the number to the standard presentation format. *)
