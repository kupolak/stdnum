(** San Marino COE (Codice operatore economico) validation.

    The COE is a tax identification number of up to 5-digits used in San Marino.
    Leading zeroes are commonly dropped. *)

exception Invalid_length
exception Invalid_format
exception Invalid_component

(** Exception raised when the COE has an invalid length (0 or more than 5
    digits). *)

(** Exception raised when the COE has less than 3 digits but is not in the list
    of valid registered low numbers. *)

val compact : string -> string
(** Convert the number to the minimal representation. This strips surrounding
    whitespace, periods, and leading zeros.

    Example: [compact "024165"] returns ["24165"] *)

val validate : string -> string
(** Check if the number is a valid COE. This checks the length, formatting, and
    for numbers with less than 3 digits, verifies they are in the list of valid
    registered numbers. Returns the normalized number if valid.

    if the number has less than 3 digits and is not in the list of valid
    registered low numbers *)

val validate_result : string -> (string, Tools.Error.t) result
(** Same as {!validate} but returns a [result] instead of raising exceptions. *)

val is_valid : string -> bool
(** Check if the number is a valid COE. Returns [true] if valid, [false]
    otherwise. *)
