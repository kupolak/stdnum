(** ЕДБ (Едниствен Даночен Број, North Macedonia tax number).

    This number consists of 13 digits, sometimes with an additional "MK" prefix.

    More information:
    - http://www.ujp.gov.mk/en *)

exception Invalid_format
(** Exception raised when the number has invalid format. *)

exception Invalid_length
(** Exception raised when the number has invalid length. *)

exception Invalid_checksum
(** Exception raised when the checksum validation fails. *)

val compact : string -> string
(** Convert the number to the minimal representation.

    This strips the number of any valid separators and removes surrounding
    whitespace. *)

val calc_check_digit : string -> string
(** Calculate the check digit. *)

val validate : string -> string
(** Check if the number is a valid North Macedonia ЕДБ number.

    This checks the length, formatting and check digit.

    @raise Invalid_format if the number contains invalid characters
    @raise Invalid_length if the length is not 13
    @raise Invalid_checksum if the checksum fails *)

val is_valid : string -> bool
(** Check if the number is a valid North Macedonia ЕДБ number. *)

val format : string -> string
(** Reformat the number to the standard presentation format. *)
