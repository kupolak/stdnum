(** n° TVA (taxe sur la valeur ajoutée, French VAT number).

    The n° TVA (Numéro d'identification à la taxe sur la valeur ajoutée) is the
    SIREN (Système d'Identification du Répertoire des Entreprises) prefixed by
    two digits. In old style numbers the two digits are numeric, with new
    style numbers at least one is alphabetic.

    Format: 2 alphanumeric characters + 9 digits (11 total)
    The first two characters can be:
    - Two digits (old style)
    - One letter + one digit, or one digit + one letter (new style)
    - Two letters (new style)
    Note: Letters I and O are not valid
*)

exception Invalid_checksum
(** Exception raised when the check digit is invalid. *)

exception Invalid_length
(** Exception raised when the number has an invalid length. *)

exception Invalid_format
(** Exception raised when the number has an invalid format. *)

exception Invalid_component
(** Exception raised when the number has an invalid component (e.g., Monaco VAT). *)

val compact : string -> string
(** Convert the number to the minimal representation. This strips the
    number of any valid separators, removes the FR prefix if present,
    and removes surrounding whitespace.

    Example: [compact "Fr 40 303 265 045"] returns ["40303265045"] *)

val validate : string -> string
(** Check if the number is a valid VAT number. This checks the length,
    formatting and check digit. Returns the normalized number if valid.

    @raise Invalid_checksum if the check digit is invalid
    @raise Invalid_format if the number has an invalid format
    @raise Invalid_length if the number has an invalid length *)

val is_valid : string -> bool
(** Check if the number is a valid VAT number.
    Returns [true] if valid, [false] otherwise. *)

val to_siren : string -> string
(** Convert the VAT number to a SIREN number.
    The SIREN number is the 9 last digits of the VAT number.

    @raise Invalid_component if the number is a Monaco VAT (starts with 000) *)
