(** NINEA (Numéro d'Identification Nationale des Entreprises et Associations,
    Senegal tax number).

    The National Identification Number for Businesses and Associations (NINEA)
    is a unique tax identifier for tax purposes in Senegal.

    This number consists of 7 digits and is usually followed by a 3 digit tax
    identification code called COFI (Code d’Identification Fiscale) that is used
    to indicate the company's tax status and legal structure.

    More information:
    - https://www.wikiprocedure.com/index.php/Senegal%5F-_Obtain_a_Tax_Identification_Number
    - https://nkac-audit.com/comprendre-le-ninea-votre-guide-de-lecture-simplifie/
    - https://www.creationdentreprise.sn/rechercher-une-societe
    - https://www.dci-sn.sn/index.php/obtenir-son-ninea
    - https://e-ninea.ansd.sn/search_annuaire *)

exception Invalid_format
(** Exception raised when the number has invalid format. *)

exception Invalid_length
(** Exception raised when the number has invalid length. *)

exception Invalid_checksum
(** Exception raised when the checksum validation fails. *)

exception Invalid_component
(** Exception raised when a component of the number is invalid. *)

val compact : string -> string
(** Convert the number to the minimal representation. This strips the number of
    any valid separators and removes surrounding whitespace. *)

val validate : string -> string
(** Check if the number is a valid Senegal NINEA. This checks the length and
    formatting. *)

val is_valid : string -> bool
(** Check if the number is a valid Senegal NINEA. *)

val format : string -> string
(** Reformat the number to the standard presentation format. *)
