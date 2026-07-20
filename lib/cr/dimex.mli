(** CR (Cédula de Residencia, Costa Rica foreigners ID number).

    The Cédula de Residencia (CR), also know as DIMEX or Documento de
    Identificación Migratorio para Extranjeros, is an identifier of foreigners in
    Costa Rica.

    This number consists of 11 or 12 digits in the form 1NNN-CC...C-EE...E where
    NNN represents the code of the country the foreigner comes from as specified
    by Costa Rica's Dirección General de Migración y Extranjería, CC...C is a
    sequence telling how many Cédula de Residencia have been issued in total and
    EE...E is a sequence telling how many Cédula de Residencia have been issued
    for that particular foreign country.

    More information:
    - https://www.hacienda.go.cr/consultapagos/ayuda_cedulas.htm
    - https://www.procomer.com/downloads/quiero/guia_solicitud_vuce.pdf (page 12)
    - https://www.hacienda.go.cr/ATV/frmConsultaSituTributaria.aspx *)

exception Invalid_format
(** Exception raised when the CR has invalid format. *)

exception Invalid_length
(** Exception raised when the CR has invalid length. *)

exception Invalid_component
(** Exception raised when the CR has an invalid component (e.g. doesn't start with 1). *)

val compact : string -> string
(** Convert the number to the minimal representation. This strips the
    number of any valid separators and removes surrounding whitespace. *)

val validate : string -> string
(** Check if the number is a valid Costa Rica CR number.

    This checks the length and formatting.

    @raise Invalid_format if the number contains invalid characters
    @raise Invalid_length if the length is not 11 or 12
    @raise Invalid_component if the number doesn't start with 1 *)

val is_valid : string -> bool
(** Check if the number is a valid Costa Rica CR number. *)

val format : string -> string
(** Reformat the number to the standard presentation format. *)
