(** CPF (Cédula de Persona Física, Costa Rica physical person ID number).

    The Cédula de Persona Física (CPF), also known as Cédula de Identidad is an
    identifier of physical persons.

    The number consists of 10 digits in the form 0P-TTTT-AAAA where P represents
    the province, TTTT represents the volume (tomo) padded with zeroes on the
    left, and AAAA represents the entry (asiento) also padded with zeroes on the
    left.

    More information:
    - https://www.hacienda.go.cr/consultapagos/ayuda_cedulas.htm
    - https://www.procomer.com/downloads/quiero/guia_solicitud_vuce.pdf (page 11)
    - https://www.hacienda.go.cr/ATV/frmConsultaSituTributaria.aspx *)

exception Invalid_format
(** Exception raised when the number format is invalid. *)

exception Invalid_length
(** Exception raised when the number length is invalid. *)

exception Invalid_component
(** Exception raised when a component of the number is invalid. *)

val compact : string -> string
(** [compact number] converts the number to the minimal representation by
    stripping separators and padding with zeros. *)

val validate : string -> string
(** [validate number] checks if the number is a valid Costa Rica CPF number.
    Returns the validated number in compact form.
    
    @raise Invalid_length if the number length is not 10 digits after compacting
    @raise Invalid_format if the number contains non-digit characters
    @raise Invalid_component if the first digit is not 0 *)

val is_valid : string -> bool
(** [is_valid number] checks if the number is a valid Costa Rica CPF number.
    Returns [true] if valid, [false] otherwise. *)

val format : string -> string
(** [format number] reformats the number to the standard presentation format
    (0P-TTTT-AAAA). *)
