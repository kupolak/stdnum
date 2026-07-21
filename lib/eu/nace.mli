(** NACE (classification for businesses in the European Union).

    The NACE (nomenclature statistique des activités économiques dans la
    Communauté européenne) is a 4-level (and up to 4 digit) code for classifying
    economic activities. It is the European implementation of the UN
    classification ISIC.

    The first 4 digits are the same in all EU countries while additional levels
    and digits may be vary between countries. This module validates the numbers
    structure.

    More information:
    - https://en.wikipedia.org/wiki/Statistical_Classification_of_Economic_Activities_in_the_European_Community
*)

exception Invalid_format
(** Exception raised when the NACE has invalid format. *)

exception Invalid_length
(** Exception raised when the NACE has invalid length. *)

exception Invalid_component
(** Exception raised when the NACE component is invalid. *)

val compact : string -> string
(** Convert the number to the minimal representation. This strips the number of
    any valid separators and removes surrounding whitespace. *)

val validate : string -> string
(** Check if the number is a valid NACE. This checks the format.

    @raise Invalid_format if the format is invalid
    @raise Invalid_length if the length is greater than 4 *)

val is_valid : string -> bool
(** Check if the number is a valid NACE. This checks the format. *)

val format : string -> string
(** Reformat the number to the standard presentation format. *)
