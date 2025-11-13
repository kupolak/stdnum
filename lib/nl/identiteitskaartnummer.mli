(** Identiteitskaartnummer, Paspoortnummer (the Dutch passport number).

    Each Dutch passport has an unique number of 9 alphanumerical characters.
    The first 2 characters are always letters and the last character is a number.
    The 6 characters in between can be either.

    The letter "O" is never used to prevent it from being confused with the number "0".
    Zeros are allowed, but are not used in numbers issued after December 2019.

    More information:
    - https://www.rvig.nl/node/356
    - https://nl.wikipedia.org/wiki/Paspoort#Nederlands_paspoort *)

exception Invalid_format
exception Invalid_length
exception Invalid_component of string

val compact : string -> string
(** Remove any formatting characters from the number and return a clean string. *)

val validate : string -> string
(** Check if the number is a valid passport number. This checks the length and format.
    @raise Invalid_length if the number is not 9 characters
    @raise Invalid_format if the format is invalid
    @raise Invalid_component if the letter 'O' is present *)

val is_valid : string -> bool
(** Check if the number is a valid Dutch passport number. *)
