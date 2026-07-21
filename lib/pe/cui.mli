(** CUI (Cédula Única de Identidad, Peruvian identity number).

    The Cédula Única de Identidad (CUI) is the unique identifier for persons
    that appears on the Documento Nacional de Identidad (DNI), the national
    identity document of Peru. The number consists of 8 digits and an optional
    extra check digit.

    More information:
    - https://www.gob.pe/235-documento-nacional-de-identidad-dni
    - https://es.wikipedia.org/wiki/Documento_Nacional_de_Identidad_(Perú) *)

exception Invalid_format
exception Invalid_length
exception Invalid_checksum

val compact : string -> string
(** Convert the number to the minimal representation. *)

val calc_check_digits : string -> string
(** Calculate the possible check digits for the CUI. *)

val to_ruc : string -> string
(** Convert the number to a valid RUC. *)

val validate : string -> string
(** Check if the number provided is a valid CUI. This checks the length,
    formatting and check digit.

    @raise Invalid_checksum if the checksum fails *)

val validate_result : string -> (string, Tools.Error.t) result
(** Same as {!validate} but returns a [result] instead of raising exceptions. *)

val is_valid : string -> bool
(** Check if the number provided is a valid CUI. *)
