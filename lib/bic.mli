(** BIC (ISO 9362 Business identifier codes).

    An ISO 9362 identifier (also: BIC, BEI, or SWIFT code) uniquely
    identifies an institution. They are commonly used to route financial
    transactions.

    The code consists of a 4 letter institution code, a 2 letter country code,
    and a 2 character location code, optionally followed by a three character
    branch code.

    More information:
    - https://en.wikipedia.org/wiki/ISO_9362 *)

exception Invalid_format
(** Exception raised when the BIC has invalid format (wrong characters). *)

exception Invalid_length
(** Exception raised when the BIC has invalid length (not 8 or 11 characters). *)

exception Invalid_component
(** Exception raised when the country code is not valid. *)

val compact : string -> string
(** Convert the number to the minimal representation. This strips the
    number of any surrounding whitespace and converts to uppercase.

    Example: [compact "ABNA BE 2A"] returns ["ABNABE2A"] *)

val validate : string -> string
(** Check if the number is a valid BIC. This checks the length
    and characters in each position. Returns the normalized number if valid.

    @raise Invalid_format if the number contains invalid characters
    @raise Invalid_length if the number is not 8 or 11 characters
    @raise Invalid_component if the country code is not valid *)

val is_valid : string -> bool
(** Check if the number is a valid BIC.
    Returns [true] if valid, [false] otherwise. *)

val format : string -> string
(** Reformat the number to the standard presentation format (uppercase).

    Example: [format "agriFRPP"] returns ["AGRIFRPP"] *)
