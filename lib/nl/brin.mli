(** BRIN number (the Dutch school identification number).

    The BRIN (Basisregistratie Instellingen) is a number to identify schools and
    related institutions. The number consists of four alphanumeric characters,
    sometimes extended with two digits to indicate the site (this complete code
    is called the vestigingsnummer).

    More information:
    - https://nl.wikipedia.org/wiki/Basisregistratie_Instellingen *)

exception Invalid_format
exception Invalid_length

val compact : string -> string
(** Remove any formatting characters from the number and return a clean string. *)

val validate : string -> string
(** Check if the number is a valid BRIN number. This currently does not
    check whether the number points to a registered school.
    @raise Invalid_length if the number is not 4 or 6 characters
    @raise Invalid_format if the number format is invalid *)

val is_valid : string -> bool
(** Check if the number is a valid BRIN number. *)
