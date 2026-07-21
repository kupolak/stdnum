(** Identity Number (Mispar Zehut, מספר זהות, Israeli identity number).

    The identity number (Mispar Zehut, מספר זהות) is issued at birth to Israeli
    citizens. The number consists of nine digits and includes a check digit.

    More information:
    - https://en.wikipedia.org/wiki/National_identification_number#Israel
    - https://en.wikipedia.org/wiki/Israeli_identity_card
    - https://he.wikipedia.org/wiki/מספר_זהות_(ישראל) *)

exception Invalid_format
exception Invalid_length
exception Invalid_checksum

val compact : string -> string
(** Convert the number to the minimal representation. This strips the number of
    any valid separators and removes surrounding whitespace. *)

val validate : string -> string
(** Check if the number provided is a valid ID. This checks the length,
    formatting and check digit.

    @raise Invalid_checksum if the checksum fails *)

val validate_result : string -> (string, Tools.Error.t) result
(** Same as {!validate} but returns a [result] instead of raising exceptions. *)

val is_valid : string -> bool
(** Check if the number provided is a valid ID. This checks the length,
    formatting and check digit. *)

val format : string -> string
(** Reformat the number to the standard presentation format. *)
