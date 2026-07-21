(** ICE (Identifiant Commun de l’Entreprise, التعريف الموحد للمقاولة, Morocco
    tax number).

    The ICE is a number that identifies the company and its branches in a unique
    and uniform way by all Moroccan administrations. It comes in addition to the
    other legal identifiers, notably the "identifiant fiscal" (IF), the "numéro
    de registre de commerce" (RC) and the CNSS number. The ICE does not replace
    these identifiers, which remain mandatory.

    The ICE is intended to ease communication among Moroccan administration
    branches, therefore simplifying procedures, increasing reliability and
    speed, and therefore reducing costs.

    The ICE applies to legal entities and their branches, as well as to natural
    persons.

    The ICE consists of 15 characters, where the first 9 represent the
    enterprise, the following 4 represent its establishments, and the last 2 are
    control characters.

    More information:
    - https://www.ice.gov.ma/
    - https://www.ice.gov.ma/ICE/Depliant_ICE.pdf
    - https://www.ice.gov.ma/ICE/Guide_ICE.pdf *)

exception Invalid_format
(** Exception raised when the number has invalid format. *)

exception Invalid_length
(** Exception raised when the number has invalid length. *)

exception Invalid_checksum
(** Exception raised when the checksum validation fails. *)

val compact : string -> string
(** Convert the number to the minimal representation.

    This strips the number of any valid separators, removes surrounding
    whitespace. *)

val validate : string -> string
(** Check if the number is a valid Morocco ICE number.

    This checks the length and formatting.

    @raise Invalid_format if the number contains invalid characters
    @raise Invalid_length if the length is not 15
    @raise Invalid_checksum if the checksum fails *)

val is_valid : string -> bool
(** Check if the number is a valid Morocco ICE number. *)

val format : string -> string
(** Reformat the number to the standard presentation format. *)
