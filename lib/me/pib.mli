(** PIB (Poreski Identifikacioni Broj, Montenegro tax number).

    This number consists of 8 digits.

    More information:
    - http://www.pretraga.crps.me:8083/
    - https://www.vatify.eu/montenegro-vat-number.html *)

exception Invalid_format
exception Invalid_length
exception Invalid_checksum

val compact : string -> string
(** Convert the number to the minimal representation.

    This strips the number of any valid separators and removes surrounding
    whitespace. *)

val calc_check_digit : string -> string
(** Calculate the check digit for the number. *)

val validate : string -> string
(** Check if the number is a valid Montenegro PIB number.

    @raise Invalid_checksum if the checksum fails *)

val validate_result : string -> (string, Tools.Error.t) result
(** Same as {!validate} but returns a [result] instead of raising exceptions. *)

val is_valid : string -> bool
(** Check if the number is a valid Montenegro PIB number. *)

val format : string -> string
(** Reformat the number to the standard presentation format. *)
