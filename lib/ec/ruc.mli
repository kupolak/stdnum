(** RUC (Registro Único de Contribuyentes, Ecuadorian company tax number).

    The RUC is a tax identification number for legal entities. It has 13 digits
    where the third digit is a number denoting the type of entity. *)

exception Invalid_format
(** Exception raised when the RUC has invalid format. *)

exception Invalid_length
(** Exception raised when the RUC has invalid length. *)

exception Invalid_component
(** Exception raised when the RUC has an invalid component (e.g. province code or entity type). *)

exception Invalid_checksum
(** Exception raised when the checksum validation fails. *)

val compact : string -> string
(** Convert the number to the minimal representation. This strips the
    number of any valid separators and removes surrounding whitespace. *)

val validate : string -> string
(** Check if the number provided is a valid RUC number. This checks the
    length, formatting, check digit and check sum.

    @raise Invalid_format if the number contains invalid characters
    @raise Invalid_length if the length is not 13
    @raise Invalid_component if the province code, establishment or third digit is invalid
    @raise Invalid_checksum if the checksum fails *)

val is_valid : string -> bool
(** Check if the number provided is a valid RUC number. *)
