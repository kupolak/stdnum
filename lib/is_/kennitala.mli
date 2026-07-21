(** Kennitala (Icelandic personal and organisation identity code).

    Module for handling Icelandic personal and organisation identity codes
    (kennitala). *)

exception Invalid_format
(** Exception raised when the number has invalid format. *)

exception Invalid_component
(** Exception raised when the date component is invalid. *)

exception Invalid_checksum
(** Exception raised when the checksum validation fails. *)

val compact : string -> string
(** Convert the kennitala to the minimal representation. This strips surrounding
    whitespace and separation dash, and converts it to upper case. *)

val validate : string -> string
(** Check if the number provided is a valid kennitala. It checks the format,
    whether a valid date is given and whether the check digit is correct.

    @raise Invalid_format if the number contains invalid characters
    @raise Invalid_component if the date component is invalid
    @raise Invalid_checksum if the checksum fails *)

val is_valid : string -> bool
(** Check if the number provided is a valid HETU. It checks the format, whether
    a valid date is given and whether the check digit is correct. *)

val format : string -> string
(** Reformat the number to the standard presentation format. *)
