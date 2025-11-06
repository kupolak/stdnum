(** San Marino COE (Codice operatore economico) validation.

    The COE is a tax identification number of up to 5-digits used in San Marino.
    Leading zeroes are commonly dropped.
*)

exception Invalid_length
(** Exception raised when the COE has an invalid length (0 or more than 5 digits). *)

exception Invalid_format
(** Exception raised when the COE contains non-digit characters. *)

exception Invalid_component
(** Exception raised when the COE has less than 3 digits but is not in the list
    of valid registered low numbers. *)

val compact : string -> string
(** Convert the number to the minimal representation. This strips surrounding
    whitespace, periods, and leading zeros.

    Example: [compact "024165"] returns ["24165"] *)

val validate : string -> string
(** Check if the number is a valid COE. This checks the length, formatting,
    and for numbers with less than 3 digits, verifies they are in the list of
    valid registered numbers. Returns the normalized number if valid.

    @raise Invalid_length if the number has 0 digits or more than 5 digits
    @raise Invalid_format if the number contains non-digit characters
    @raise Invalid_component if the number has less than 3 digits and is not
           in the list of valid registered low numbers *)

val is_valid : string -> bool
(** Check if the number is a valid COE. Returns [true] if valid, [false] otherwise. *)
