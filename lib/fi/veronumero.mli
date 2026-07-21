(** Veronumero (Finnish individual tax number).

    The Veronumero an individual tax number that is assigned to workers in the
    construction industry in Finland. The number is separate from the HETU and
    is a 12 digit number without any embedded information such as birth dates.

    More information:
    - https://www.vero.fi/en/detailed-guidance/guidance/48791/individual_tax_numbers__instructions_fo/
    - https://prosentti.vero.fi/Veronumerorekisteri/Tarkistus/VeronumeronTarkistus.aspx
*)

exception Invalid_format
(** Exception raised when the number has invalid format. *)

exception Invalid_length
(** Exception raised when the number has invalid length. *)

val compact : string -> string
(** Convert the Veronumero to the minimal representation. This strips
    surrounding whitespace and removes separators. *)

val validate : string -> string
(** Check if the number is a valid tax number. This checks the length and
    formatting.

    @raise Invalid_format if the number contains invalid characters
    @raise Invalid_length if the length is not 12 *)

val is_valid : string -> bool
(** Check if the number is a valid tax number. *)
