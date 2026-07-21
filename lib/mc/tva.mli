(** n° TVA (taxe sur la valeur ajoutée, Monacan VAT number).

    For VAT purposes Monaco is treated as territory of France. The number is
    also validated the same as the French TVA, except that it is not based on a
    French SIREN. *)

exception Invalid_component

val compact : string -> string
(** Convert the number to the minimal representation. This strips the number of
    any valid separators and removes surrounding whitespace. *)

val validate : string -> string
(** Check if the number is a valid VAT number. This checks the length,
    formatting and check digit.

    @raise Fr.Tva.Invalid_format if the number contains invalid characters
    @raise Fr.Tva.Invalid_length if the length is not 11
    @raise Fr.Tva.Invalid_checksum if the checksum fails
    @raise Invalid_component if the SIREN part does not start with 000 *)

val validate_result : string -> (string, Tools.Error.t) result
(** Same as {!validate} but returns a [result] instead of raising exceptions. *)

val is_valid : string -> bool
(** Check if the number is a valid VAT number. *)
