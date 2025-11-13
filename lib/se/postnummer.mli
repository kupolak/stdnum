(** Swedish Postnummer (postal code).

    The Swedish postal code consists of five digits, where the first three digits
    represent an area and the last two digits represent a delivery point or district.
    The code is typically formatted with a space between the third and fourth digits.

    The postal code cannot start with '0'. The 'SE' prefix (country code) is
    sometimes used but is stripped during validation.

    More information:
    - https://en.wikipedia.org/wiki/Postal_codes_in_Sweden
    - https://sv.wikipedia.org/wiki/Postnummer_i_Sverige
*)

exception Invalid_length
(** Exception raised when the number has an invalid length (not 5 digits). *)

exception Invalid_format
(** Exception raised when the number contains non-digit characters or starts with '0'. *)

val compact : string -> string
(** Convert the number to the minimal representation. This strips spaces and dashes,
    removes the 'SE' prefix if present, and removes surrounding whitespace.

    Example: [compact "SE-11418"] returns ["11418"]
    Example: [compact "114 18"] returns ["11418"] *)

val validate : string -> string
(** Check if the number is a valid postal code. This checks the length and format.
    Note: This does not verify whether the code corresponds to a real address.

    @raise Invalid_format if the number contains non-digit characters or starts with '0'
    @raise Invalid_length if the number is not 5 digits *)

val is_valid : string -> bool
(** Check if the number is a valid postal code.
    Returns [true] if valid, [false] otherwise. *)

val format : string -> string
(** Reformat the number to the standard presentation format (XXX XX).

    Example: [format "11418"] returns ["114 18"] *)
