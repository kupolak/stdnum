(** Cedula (Dominican Republic national identification number).

    A cedula is an 11-digit number issued by the Dominican Republic government
    to citizens or residents for identification purposes.

    More information:
    - https://dgii.gov.do/ *)

exception Invalid_format
exception Invalid_length
exception Invalid_checksum

val compact : string -> string
(** Remove any formatting characters from the number and return a clean string. *)

val validate : string -> string
(** Validate the cedula number and return the compacted version.
    @raise Invalid_format if the number contains invalid characters
    @raise Invalid_length if the number is not 11 digits
    @raise Invalid_checksum if the Luhn checksum is invalid *)

val is_valid : string -> bool
(** Check if the cedula number is valid. *)

val format : string -> string
(** Format the cedula number in the standard XXX-XXXXXXX-X format. *)
