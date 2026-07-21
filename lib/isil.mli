(** ISIL (International Standard Identifier for Libraries).

    The ISIL is the International Standard Identifier for Libraries and Related
    Organizations (ISO 15511) used to uniquely identify libraries, archives,
    museums, and similar organisations.

    The identifier can be up to 15 characters that may use digits, letters (case
    insensitive) hyphens, colons and slashes. The non-alphanumeric characters
    are part of the identifier and are not just for readability.

    More information:
    - https://biblstandard.dk/isil/
    - https://www.iso.org/standard/57332.html *)

exception Invalid_format
(** Exception raised when the number has invalid format. *)

exception Invalid_length
(** Exception raised when the number has invalid length. *)

exception Invalid_component
(** Exception raised when a component of the number is invalid. *)

val compact : string -> string
(** Convert the ISIL to the minimal representation. This strips surrounding
    whitespace. *)

val validate : string -> string
(** Check if the number provided is a valid ISIL.

    @raise Invalid_format if the number contains invalid characters
    @raise Invalid_length if the length is greater than 15 *)

val is_valid : string -> bool
(** Check if the number provided is a valid ISIL. *)

val format : string -> string
(** Reformat the number to the standard presentation format. *)
