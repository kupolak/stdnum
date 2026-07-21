(** NIT (Número De Identificación Tributaria, Colombian identity code).

    This number, also referred to as RUT (Registro Unico Tributario) is the
    Colombian business tax number.

    More information:
    - https://www.dian.gov.co/ *)

exception Invalid_format
exception Invalid_length
exception Invalid_checksum

val compact : string -> string
(** [compact number] converts the number to the minimal representation by
    stripping separators and whitespace. *)

val calc_check_digit : string -> string
(** [calc_check_digit number] calculates the check digit for a NIT number
    without the check digit. *)

val validate : string -> string
(** [validate number] checks if the number is a valid NIT number. Returns the
    validated number in compact form.

    @raise Invalid_checksum if the check digit is invalid *)

val validate_result : string -> (string, Tools.Error.t) result
(** Same as {!validate} but returns a [result] instead of raising exceptions. *)

val is_valid : string -> bool
(** [is_valid number] checks if the number is a valid NIT number. Returns [true]
    if valid, [false] otherwise. *)

val format : string -> string
(** [format number] reformats the number to the standard presentation format. *)
