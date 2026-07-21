(** MEID (Mobile Equipment Identifier).

    The Mobile Equipment Identifier is used to identify a physical piece of CDMA
    mobile station equipment.

    More information:
    - https://en.wikipedia.org/wiki/Mobile_Equipment_Identifier *)

exception Invalid_format
exception Invalid_length
exception Invalid_component
exception Invalid_checksum

val compact_clean : ?strip_check_digit:bool -> string -> string
(** Convert the MEID number to the minimal (hexadecimal) representation. This
    strips grouping information, removes surrounding whitespace and converts to
    hexadecimal if needed. If the check digit is to be preserved and conversion
    is done a new check digit is recalculated. *)

val calc_check_digit : string -> string
(** Calculate the check digit for the number. The number should not already have
    a check digit. *)

val validate : ?strip_check_digit:bool -> string -> string
(** Check if the number is a valid MEID number. This converts the representation
    format of the number (if it is decimal it is not converted to hexadecimal).
*)

val validate_result : string -> (string, Tools.Error.t) result
(** Same as {!validate} but returns a [result] instead of raising exceptions. *)

val is_valid : string -> bool
(** Check if the number is a valid MEID number. Returns [true] if valid, [false]
    otherwise. *)

val format :
  ?separator:string -> ?fmt:string -> ?add_check_digit:bool -> string -> string
(** Reformat the number to the standard presentation format. The separator used
    can be provided. If the format is specified (either "hex" or "dec") the
    number is reformatted in that format, otherwise the current representation
    is kept. If add_check_digit is true a check digit will be added if it is not
    present yet. *)
