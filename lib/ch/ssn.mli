(** SSN, Sozialversicherungsnummer (Swiss social security number).

    The Swiss Sozialversicherungsnummer (also known as "Neue AHV Nummer") is
    used to identify individuals for taxation and pension purposes.

    The number is validated using EAN-13, though dashes are substituted for dots.
    The number must start with '756' (Swiss country code).

    More information:
    - https://en.wikipedia.org/wiki/National_identification_number#Switzerland
    - https://de.wikipedia.org/wiki/Sozialversicherungsnummer#Versichertennummer *)

exception Invalid_format
exception Invalid_length
exception Invalid_checksum
exception Invalid_component

val compact : string -> string
(** Convert the number to the minimal representation. *)

val validate : string -> string
(** Check if the number is a valid Swiss social security number.
    @raise Invalid_format if the number contains invalid characters
    @raise Invalid_length if the number is not 13 digits
    @raise Invalid_component if the number doesn't start with 756
    @raise Invalid_checksum if the checksum is invalid *)

val is_valid : string -> bool
(** Check if the number is a valid Swiss social security number. *)

val format : string -> string
(** Reformat the number to the standard presentation format (756.XXXX.XXXX.XX). *)
