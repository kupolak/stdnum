(** EMŠO (Unique Master Citizen Number).

    The EMŠO is a 13-digit unique citizen number used in Slovenia. The number
    consists of the date of birth (7 digits), a region code (2 digits), a
    personal number (3 digits) with the last three digits encoding gender
    (< 500 for males, >= 500 for females), and a check digit (1 digit).
*)

exception Invalid_checksum
(** Exception raised when the check digit is invalid. *)

exception Invalid_length
(** Exception raised when the number has an invalid length. *)

exception Invalid_format
(** Exception raised when the number has an invalid format. *)

exception Invalid_component
(** Exception raised when a component (date, region) is invalid. *)

val compact : string -> string
(** Convert the number to the minimal representation. *)

val calc_check_digit : string -> string
(** Calculate the check digit for the given 12-digit number.
    Uses weighted sum with weights (7,6,5,4,3,2,7,6,5,4,3,2). *)

val get_birth_date : string -> int * int * int
(** Extract the birth date from the number as (year, month, day).
    Years < 800 are interpreted as 20xx, otherwise as 19xx.

    @raise Invalid_component if the date is invalid *)

val get_gender : string -> string
(** Return the gender from the EMŠO.
    Returns "M" if the personal number (digits 9-12) < 500, "F" otherwise. *)

val get_region : string -> string
(** Return the birth region encoded in the number. *)

val validate : string -> string
(** Check if the number is a valid EMŠO. Returns the normalized number if valid.

    @raise Invalid_checksum if the check digit is invalid
    @raise Invalid_format if the number contains non-digits
    @raise Invalid_length if the number has an invalid length
    @raise Invalid_component if the date or region is invalid *)

val is_valid : string -> bool
(** Check if the number is a valid EMŠO. Returns [true] if valid, [false] otherwise. *)

val format : string -> string
(** Reformat the number to the standard presentation format.

    Example: [format "0101006500006"] returns ["0101006500006"] *)
