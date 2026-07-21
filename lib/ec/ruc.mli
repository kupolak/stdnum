(** RUC (Registro Único de Contribuyentes, Ecuadorian company tax number).

    The RUC is a tax identification number for legal entities. It has 13 digits
    where the third digit is a number denoting the type of entity. *)

exception Invalid_format
exception Invalid_length
exception Invalid_component
exception Invalid_checksum

(** Exception raised when the RUC has an invalid component (e.g. province code
    or entity type). *)

val compact : string -> string
(** Convert the number to the minimal representation. This strips the number of
    any valid separators and removes surrounding whitespace. *)

val validate : string -> string
(** Check if the number provided is a valid RUC number. This checks the length,
    formatting, check digit and check sum.

    if the province code, establishment or third digit is invalid
    @raise Invalid_checksum if the checksum fails *)

val validate_result : string -> (string, Tools.Error.t) result
(** Same as {!validate} but returns a [result] instead of raising exceptions. *)

val is_valid : string -> bool
(** Check if the number provided is a valid RUC number. *)
