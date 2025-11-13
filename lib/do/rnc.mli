(** RNC (Registro Nacional del Contribuyente, Dominican Republic tax number).

    The RNC is the Dominican Republic taxpayer registration number for
    institutions. The number consists of 9 digits. *)

exception Invalid_format
exception Invalid_length
exception Invalid_checksum

val compact : string -> string
(** Convert the number to the minimal representation. This strips the
    number of any valid separators and removes surrounding whitespace. *)

val calc_check_digit : string -> string
(** Calculate the check digit for the first 8 digits. *)

val validate : string -> string
(** Check if the number provided is a valid RNC.
    Raises Invalid_format, Invalid_length, or Invalid_checksum if invalid. *)

val is_valid : string -> bool
(** Check if the number provided is a valid RNC. *)

val format : string -> string
(** Reformat the number to the standard presentation format (X-XX-XXXXX-X). *)
