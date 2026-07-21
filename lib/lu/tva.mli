(** TVA (taxe sur la valeur ajoutée, Luxembourgian VAT number).

    The n° TVA (Numéro d'identification à la taxe sur la valeur ajoutée) is used
    for tax purposes in Luxembourg. The number consists of 8 digits of which the
    last two are check digits. *)

exception Invalid_format
exception Invalid_length
exception Invalid_checksum

val compact : string -> string
(** Convert the number to the minimal representation. This strips the number of
    any valid separators and removes surrounding whitespace. *)

val calc_check_digits : string -> string
(** Calculate the check digits for the number. *)

val validate : string -> string
(** Check if the number is a valid VAT number. This checks the length,
    formatting and check digit.

    @raise Invalid_checksum if the checksum fails *)

val validate_result : string -> (string, Tools.Error.t) result
(** Same as {!validate} but returns a [result] instead of raising exceptions. *)

val is_valid : string -> bool
(** Check if the number is a valid VAT number. *)
