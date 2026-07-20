(** CUIT (Código Único de Identificación Tributaria, Argentinian tax number).

    The CUIT is a taxpayer identification number used for VAT (IVA, Impuesto al
    Valor Agregado) and other taxes.

    More information:
    - https://es.wikipedia.org/wiki/Clave_Única_de_Identificación_Tributaria *)

exception Invalid_format
(** Exception raised when the CUIT has invalid format. *)

exception Invalid_length
(** Exception raised when the CUIT has invalid length. *)

exception Invalid_component
(** Exception raised when the CUIT has an invalid prefix. *)

exception Invalid_checksum
(** Exception raised when the checksum validation fails. *)

val compact : string -> string
(** Convert the number to the minimal representation. This strips the
    number of any valid separators and removes surrounding whitespace. *)

val calc_check_digit : string -> string
(** Calculate the check digit. *)

val validate : string -> string
(** Check if the number is a valid CUIT.

    @raise Invalid_format if the number contains invalid characters
    @raise Invalid_length if the length is not 11
    @raise Invalid_component if the prefix is not valid
    @raise Invalid_checksum if the checksum fails *)

val is_valid : string -> bool
(** Check if the number is a valid CUIT. *)

val format : string -> string
(** Reformat the number to the standard presentation format. *)
