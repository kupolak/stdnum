(** CI (Cédula de identidad, Ecuadorian personal identity code).

    The CI is a 10 digit number used to identify Ecuadorian citizens. *)

exception Invalid_format
(** Exception raised when the CI has invalid format. *)

exception Invalid_length
(** Exception raised when the CI has invalid length. *)

exception Invalid_component
(** Exception raised when the CI has an invalid province code or third digit. *)

exception Invalid_checksum
(** Exception raised when the checksum validation fails. *)

val compact : string -> string
(** Convert the number to the minimal representation. This strips the
    number of any valid separators and removes surrounding whitespace. *)

val validate : string -> string
(** Check if the number provided is a valid CI number. This checks the
    length, formatting and check digit.

    @raise Invalid_format if the number contains invalid characters
    @raise Invalid_length if the length is not 10
    @raise Invalid_component if the province code or third digit is invalid
    @raise Invalid_checksum if the checksum fails *)

val is_valid : string -> bool
(** Check if the number provided is a valid CI number. *)
