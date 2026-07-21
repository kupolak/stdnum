(** SIREN (Système d'Identification du Répertoire des Entreprises).

    The SIREN is a 9-digit French company identification number. It is validated
    using the Luhn checksum algorithm. *)

exception Invalid_checksum
exception Invalid_length
exception Invalid_format

val compact : string -> string
(** Convert the number to the minimal representation. *)

val validate : string -> string
(** Check if the number is a valid SIREN. Returns the normalized number if
    valid.

    @raise Invalid_length if the number has an invalid length *)

val validate_result : string -> (string, Tools.Error.t) result
(** Same as {!validate} but returns a [result] instead of raising exceptions. *)

val is_valid : string -> bool
(** Check if the number is a valid SIREN. Returns [true] if valid, [false]
    otherwise. *)

val to_tva : string -> string
(** Return a TVA that prepends the two extra check digits to the SIREN. Note:
    This always returns numeric check digits.

    Example: [to_tva "443 121 975"] returns ["46 443 121 975"] *)

val format : ?separator:string -> string -> string
(** Reformat the number to the standard presentation format. Default separator
    is a space.

    Example: [format "404833048"] returns ["404 833 048"] *)
