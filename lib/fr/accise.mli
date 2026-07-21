(** n° d'accise (French number to identify taxpayers of excise taxes).

    The n° d'accise always start by FR0 following by the 2 ending digits of the
    year, 3 number of customs office, one letter for the type and an ordering
    number of 4 digits. *)

exception Invalid_format
exception Invalid_length
exception Invalid_component

val compact : string -> string
(** Convert the number to the minimal representation. This strips the number of
    any valid separators and removes surrounding whitespace. *)

val validate : string -> string
(** Check if the number is a valid accise number. This checks the length,
    formatting.

    @raise Invalid_component if the operator type is invalid *)

val validate_result : string -> (string, Tools.Error.t) result
(** Same as {!validate} but returns a [result] instead of raising exceptions. *)

val is_valid : string -> bool
(** Check if the number is a valid accise number. *)
