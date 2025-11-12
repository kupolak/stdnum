(** NIE (Número de Identificación de Extranjero, Spanish foreigner number).

    The NIE is an identification number for foreigners. It is a 9 digit number
    where the first digit is either X, Y or Z and last digit is a checksum
    letter. *)

exception Invalid_length
exception Invalid_format
exception Invalid_checksum

val compact : string -> string
(** Remove any extra formatting characters like spaces and hyphens, and convert to uppercase. *)

val calc_check_digit : string -> string
(** Calculate the check digit. The number passed should not have the check digit included. *)

val validate : string -> string
(** Check if the number provided is a valid NIE. This checks the length,
    formatting and check digit. Returns the compacted number if valid, raises an exception otherwise. *)

val is_valid : string -> bool
(** Check if the number provided is a valid NIE. Returns true if valid, false otherwise. *)
