(** NHS (United Kingdom National Health Service patient identifier).

    The NHS number is used by the NHS (National Health Service) and its partners
    to uniquely identify patients. The number is used in England, Wales and the
    Isle of Man. The number is assigned at birth and consists of 10 digits where
    the final digit is a check digit.

    More information:
    - https://en.wikipedia.org/wiki/NHS_number *)

exception Invalid_format
exception Invalid_length
exception Invalid_checksum

val compact : string -> string
(** Convert the number to the minimal representation. This strips the number of
    any valid separators and removes surrounding whitespace. *)

val checksum : string -> int
(** Calculate the checksum. The checksum is only used for the 9 digits of the
    number and the result can either be 0 or 42. *)

val validate : string -> string
(** Check if the number is valid. This checks the length and check digit.

    @raise Invalid_checksum if the checksum fails *)

val validate_result : string -> (string, Tools.Error.t) result
(** Same as {!validate} but returns a [result] instead of raising exceptions. *)

val is_valid : string -> bool
(** Check if the number is valid. *)

val format : ?separator:string -> string -> string
(** Reformat the number to the standard presentation format. *)
