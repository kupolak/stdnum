(** VAT (United Kingdom (and Isle of Man) VAT registration number).

    The VAT number can either be a 9-digit standard number, a 12-digit standard
    number followed by a 3-digit branch identifier, a 5-digit number for
    government departments (first two digits are GD) or a 5-digit number for
    health authorities (first two digits are HA). The 9-digit variants use a
    weighted checksum.

    More information:
    - https://en.wikipedia.org/wiki/VAT_identification_number *)

exception Invalid_format
(** Exception raised when the VAT number has invalid format. *)

exception Invalid_length
(** Exception raised when the VAT number has invalid length. *)

exception Invalid_component
(** Exception raised when the VAT number has an invalid component. *)

exception Invalid_checksum
(** Exception raised when the checksum validation fails. *)

val compact : string -> string
(** Convert the number to the minimal representation. This strips the
    number of any valid separators and removes surrounding whitespace. *)

val checksum : string -> int
(** Calculate the checksum. The checksum is only used for the 9 digits
    of the number and the result can either be 0 or 42. *)

val validate : string -> string
(** Check if the number is a valid VAT number. This checks the length,
    formatting and check digit.

    @raise Invalid_format if the number contains invalid characters
    @raise Invalid_length if the length is invalid
    @raise Invalid_component if the component validation fails
    @raise Invalid_checksum if the checksum fails *)

val is_valid : string -> bool
(** Check if the number is a valid VAT number. *)

val format : string -> string
(** Reformat the number to the standard presentation format. *)
