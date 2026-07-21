(** NIT (Número de Identificación Tributaria, Guatemala tax number).

    The Número de Identificación Tributaria (NIT) is an identifier of legal
    entities for tax purposes in Guatemala.

    The number consists of 2 to 12 characters, where the last one is the check
    digit (a digit or the letter K) and the rest are digits. Leading zeroes are
    usually omitted. Digits and check digit are usually separated with a hyphen.

    More information:
    - https://portal.sat.gob.gt/portal/descarga/6524/factura-electronica-fel/25542/fel-reglas-y-validaciones.pdf
      (page 58)
    - https://portal.sat.gob.gt/portal/consulta-cui-nit/ *)

exception Invalid_format
(** Exception raised when the number has invalid format. *)

exception Invalid_length
(** Exception raised when the number has invalid length. *)

exception Invalid_checksum
(** Exception raised when the checksum validation fails. *)

val compact : string -> string
(** Convert the number to the minimal representation. This strips the number of
    any valid separators and removes surrounding whitespace. *)

val validate : string -> string
(** Check if the number is a valid Guatemala NIT number. This checks the length,
    formatting and check digit.

    @raise Invalid_format if the number contains invalid characters
    @raise Invalid_length if the length is incorrect
    @raise Invalid_checksum if the checksum fails *)

val is_valid : string -> bool
(** Check if the number is a valid Guatemala NIT number. *)

val format : string -> string
(** Reformat the number to the standard presentation format. *)
