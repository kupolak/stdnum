(** Wertpapierkennnummer (German securities identification code).

    The WKN, WPKN, WPK (Wertpapierkennnummer) is a German code to identify
    securities. It is a 6-digit alphanumeric number without a check digit that no
    longer has any structure. It is expected to be replaced by the ISIN.

    More information:
    - https://en.wikipedia.org/wiki/Wertpapierkennnummer *)

exception Invalid_format
exception Invalid_length

val compact : string -> string
(** Convert the number to the minimal representation. *)

val validate : string -> string
(** Check if the number provided is valid. This checks the length and format.
    @raise Invalid_format if the number contains invalid characters (O and I are not allowed)
    @raise Invalid_length if the number is not 6 characters *)

val is_valid : string -> bool
(** Check if the number provided is valid. *)

val to_isin : string -> string
(** Convert the WKN number to an ISIN (with DE country code). *)
