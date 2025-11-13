(** Postcode (the Dutch postal code).

    The Dutch postal code consists of four numbers followed by two letters,
    separated by a single space.

    More information:
    - https://en.wikipedia.org/wiki/Postal_codes_in_the_Netherlands
    - https://nl.wikipedia.org/wiki/Postcodes_in_Nederland *)

exception Invalid_format
exception Invalid_component

val compact : string -> string
(** Remove any formatting characters from the number and strip NL prefix if present. *)

val validate : string -> string
(** Check if the number is in the correct format. This currently does not
    check whether the code corresponds to a real address.
    Returns the formatted postcode with space (XXXX XX).
    @raise Invalid_format if the format is invalid
    @raise Invalid_component if the letter combination is blacklisted (SA, SD, SS) *)

val is_valid : string -> bool
(** Check if the number is a valid postal code. *)
