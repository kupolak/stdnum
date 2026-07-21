(** CUIT (Código Único de Identificación Tributaria, Argentinian tax number).

    The CUIT is a taxpayer identification number used for VAT (IVA, Impuesto al
    Valor Agregado) and other taxes.

    More information:
    - https://es.wikipedia.org/wiki/Clave_Única_de_Identificación_Tributaria *)

exception Invalid_format
exception Invalid_length
exception Invalid_component
exception Invalid_checksum

val compact : string -> string
(** Convert the number to the minimal representation. This strips the number of
    any valid separators and removes surrounding whitespace. *)

val calc_check_digit : string -> string
(** Calculate the check digit. *)

val validate : string -> string
(** Check if the number is a valid CUIT.

    @raise Invalid_checksum if the checksum fails *)

val validate_result : string -> (string, Tools.Error.t) result
(** Same as {!validate} but returns a [result] instead of raising exceptions. *)

val is_valid : string -> bool
(** Check if the number is a valid CUIT. *)

val format : string -> string
(** Reformat the number to the standard presentation format. *)
