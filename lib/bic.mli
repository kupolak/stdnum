(** BIC (ISO 9362 Business identifier codes).

    An ISO 9362 identifier (also: BIC, BEI, or SWIFT code) uniquely identifies
    an institution. They are commonly used to route financial transactions.

    The code consists of a 4 letter institution code, a 2 letter country code,
    and a 2 character location code, optionally followed by a three character
    branch code.

    More information:
    - https://en.wikipedia.org/wiki/ISO_9362 *)

exception Invalid_format
exception Invalid_length
exception Invalid_component

(** Exception raised when the BIC has invalid length (not 8 or 11 characters).
*)

val compact : string -> string
(** Convert the number to the minimal representation. This strips the number of
    any surrounding whitespace and converts to uppercase.

    Example: [compact "ABNA BE 2A"] returns ["ABNABE2A"] *)

val validate : string -> string
(** Check if the number is a valid BIC. This checks the length and characters in
    each position. Returns the normalized number if valid.

    @raise Invalid_component if the country code is not valid *)

val validate_result : string -> (string, Tools.Error.t) result
(** Same as {!validate} but returns a [result] instead of raising exceptions. *)

val is_valid : string -> bool
(** Check if the number is a valid BIC. Returns [true] if valid, [false]
    otherwise. *)

val format : string -> string
(** Reformat the number to the standard presentation format (uppercase).

    Example: [format "agriFRPP"] returns ["AGRIFRPP"] *)
