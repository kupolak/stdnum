(** NIT (Número De Identificación Tributaria, Colombian identity code).

    This number, also referred to as RUT (Registro Unico Tributario) is the
    Colombian business tax number.

    More information:
    - https://www.dian.gov.co/ *)

exception Invalid_format
(** Exception raised when the number format is invalid. *)

exception Invalid_length
(** Exception raised when the number length is invalid. *)

exception Invalid_checksum
(** Exception raised when the check digit is invalid. *)

val compact : string -> string
(** [compact number] converts the number to the minimal representation by
    stripping separators and whitespace. *)

val calc_check_digit : string -> string
(** [calc_check_digit number] calculates the check digit for a NIT number
    without the check digit. *)

val validate : string -> string
(** [validate number] checks if the number is a valid NIT number.
    Returns the validated number in compact form.
    
    @raise Invalid_length if the number length is not between 8 and 16 digits
    @raise Invalid_format if the number contains non-digit characters
    @raise Invalid_checksum if the check digit is invalid *)

val is_valid : string -> bool
(** [is_valid number] checks if the number is a valid NIT number.
    Returns [true] if valid, [false] otherwise. *)

val format : string -> string
(** [format number] reformats the number to the standard presentation format. *)
