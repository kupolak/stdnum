(** CPJ (Cédula de Persona Jurídica, Costa Rica tax number).

    The Cédula de Persona Jurídica (CPJ) is an identifier of legal entities for
    tax purposes.

    This number consists of 10 digits, the first indicates the class of
    juridical person, followed by a 3 digit sequence number identifying the type
    of juridical person, followed by 6 digits sequence number assigned by
    Registro Nacional de la República de Costa Rica.

    More information:
    - https://www.hacienda.go.cr/consultapagos/ayuda_cedulas.htm
    - https://www.procomer.com/downloads/quiero/guia_solicitud_vuce.pdf (page
      11)
    - https://rnpdigital.com/personas_juridicas/documentos/Consultas/Listado%20de%20Clases%20y%20Tipos%20Cedulas%20Juridicas.pdf
    - https://www.hacienda.go.cr/ATV/frmConsultaSituTributaria.aspx *)

exception Invalid_format
(** Exception raised when the CPJ has invalid format. *)

exception Invalid_length
(** Exception raised when the CPJ has invalid length. *)

exception Invalid_component
(** Exception raised when the CPJ has an invalid component (e.g. invalid type).
*)

val compact : string -> string
(** Convert the number to the minimal representation. This strips the number of
    any valid separators and removes surrounding whitespace. *)

val validate : string -> string
(** Check if the number is a valid Costa Rica CPJ number.

    This checks the length and formatting.

    @raise Invalid_format if the number contains invalid characters
    @raise Invalid_length if the length is not 10
    @raise Invalid_component if the type of juridical person is invalid *)

val is_valid : string -> bool
(** Check if the number is a valid Costa Rica CPJ number. *)

val format : string -> string
(** Reformat the number to the standard presentation format. *)
