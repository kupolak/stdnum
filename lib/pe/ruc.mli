(** RUC (Registro Único de Contribuyentes, Peruvian company tax number).

    The RUC (Registro Único de Contribuyentes) is the tax number of Peru
    assigned to legal and natural persons. The number consists of 11 digits, the
    first two indicate the kind of number, for personal numbers it is followed
    by the DNI and a check digit.

    More information:
    - https://www.sunat.gob.pe/legislacion/ruc/
    - https://consultarelruc.pe/ *)

exception Invalid_format
(** Exception raised when the number has invalid format. *)

exception Invalid_length
(** Exception raised when the number has invalid length. *)

exception Invalid_checksum
(** Exception raised when the checksum validation fails. *)

exception Invalid_component
(** Exception raised when a component of the number is invalid. *)

val compact : string -> string
(** Convert the number to the minimal representation. *)

val calc_check_digit : string -> string
(** Calculate the check digit. *)

val to_dni : string -> string
(** Return the DNI (CUI) part of the number for natural persons. *)

val validate : string -> string
(** Check if the number provided is a valid RUC. This checks the length,
    formatting and check digit.

    @raise Invalid_format if the number contains invalid characters
    @raise Invalid_length if the length is not 11
    @raise Invalid_checksum if the checksum fails
    @raise Invalid_component if the prefix is invalid *)

val is_valid : string -> bool
(** Check if the number provided is a valid RUC. This checks the length,
    formatting and check digit. *)
