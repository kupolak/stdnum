(** VSK number (Virðisaukaskattsnúmer, Icelandic VAT number).

    The Icelandic VAT number is five or six digits. *)

exception Invalid_format
(** Exception raised when the number has invalid format. *)

exception Invalid_length
(** Exception raised when the number has invalid length. *)

val compact : string -> string
(** Convert the number to the minimal representation. This strips the
    number of any valid separators and removes surrounding whitespace. *)

val validate : string -> string
(** Check if the number provided is a valid VAT number. This checks the
    length and formatting.

    @raise Invalid_format if the number contains invalid characters
    @raise Invalid_length if the length is not 5 or 6 *)

val is_valid : string -> bool
(** Check if the number provided is a valid VAT number. This checks the
    length and formatting. *)
