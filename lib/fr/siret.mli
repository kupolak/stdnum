(** SIRET (Système d'Identification du Répertoire des ETablissements).

    The SIRET is a 14-digit French company establishment identification number.
    It consists of the 9-digit SIREN number followed by a 5-digit NIC (Numéro
    Interne de Classement) that identifies the establishment. The Luhn checksum
    is used to validate the numbers (except for La Poste). *)

exception Invalid_checksum
exception Invalid_length
exception Invalid_format

val compact : string -> string
(** Convert the number to the minimal representation. *)

val validate : string -> string
(** Check if the number is a valid SIRET. Returns the normalized number if
    valid.

    @raise Invalid_length if the number has an invalid length *)

val validate_result : string -> (string, Tools.Error.t) result
(** Same as {!validate} but returns a [result] instead of raising exceptions. *)

val is_valid : string -> bool
(** Check if the number is a valid SIRET. Returns [true] if valid, [false]
    otherwise. *)

val to_siren : string -> string
(** Convert the SIRET number to a SIREN number. The SIREN number is the first 9
    digits of the SIRET number.

    Example: [to_siren "732 829 320 00074"] returns ["732 829 320"] *)

val to_tva : string -> string
(** Convert the SIRET number to a TVA number. The TVA number is built from the
    SIREN number.

    Example: [to_tva "732 829 320 00074"] returns ["44 732 829 320"] *)

val format : ?separator:string -> string -> string
(** Reformat the number to the standard presentation format. Default separator
    is a space.

    Example: [format "73282932000074"] returns ["732 829 320 00074"] *)
