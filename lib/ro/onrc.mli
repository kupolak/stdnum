(** Romanian ONRC (Ordine din Registrul Comerţului, Trade Register identifier).

    All businesses in Romania have to register with the National Trade
    Register Office to receive a registration number. The number contains
    information about the type of company, county, a sequence number and
    registration year. This number can change when registration information
    changes.

    The format is: [Type][County]/[Serial]/[Year]
    - Type: J (Judeţ/County), F (Filiala/Branch), C (Cooperativa/Cooperative)
    - County: 1-40, 51, 52
    - Serial: up to 5 digits
    - Year: 4 digits (1990-present)

    More information:
    - https://en.wikipedia.org/wiki/Registrul_Comertului
*)

exception Invalid_length
(** Exception raised when a component has an invalid length. *)

exception Invalid_format
(** Exception raised when the number has an invalid format. *)

exception Invalid_component
(** Exception raised when a component (type, county, or year) is invalid. *)

val compact : string -> string
(** Convert the number to the minimal representation. This strips the
    number of any valid separators, normalizes slashes, removes surrounding
    whitespace, and converts full dates to year only.

    Example: [compact "J 52/750/2012"] returns ["J52/750/2012"]
    Example: [compact "J52/750/01.01.2012"] returns ["J52/750/2012"] *)

val validate : string -> string
(** Check if the number is a valid ONRC. This checks the format, type,
    county, serial length, and year range. Returns the normalized number
    if valid.

    @raise Invalid_format if the number has an invalid format
    @raise Invalid_component if the type, county, or year is invalid
    @raise Invalid_length if the serial number or year has invalid length *)

val is_valid : string -> bool
(** Check if the number is a valid ONRC.
    Returns [true] if valid, [false] otherwise. *)
