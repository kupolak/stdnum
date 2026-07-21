(** VNR, SVNR, VSNR (Versicherungsnummer, Austrian social security number).

    The Austian Versicherungsnummer is a personal identification number used for
    social security. The number is 10 digits long and consists of a 3 digit
    serial, a check digit and 6 digits that usually specify the person's birth
    date.

    More information:
    - https://de.wikipedia.org/wiki/Sozialversicherungsnummer#Österreich *)

exception Invalid_format
(** Exception raised when the VNR has invalid format. *)

exception Invalid_length
(** Exception raised when the VNR has invalid length. *)

exception Invalid_checksum
(** Exception raised when the checksum validation fails. *)

val compact : string -> string
(** Convert the number to the minimal representation. This strips the number of
    any valid separators and removes surrounding whitespace. *)

val calc_check_digit : string -> string
(** Calculate the check digit. The fourth digit in the number is ignored during
    this calculation. *)

val validate : string -> string
(** Check if the number is a valid VNR number. This checks the length,
    formatting and check digit.

    @raise Invalid_format if the number contains invalid characters
    @raise Invalid_length if the length is not 10
    @raise Invalid_checksum if the checksum fails *)

val is_valid : string -> bool
(** Check if the number is a valid VNR number. *)
