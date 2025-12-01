(** NIF (Numéro d'Immatriculation Fiscale, French tax identification number).

    The NIF (Numéro d'Immatriculation Fiscale or Numéro d'Identification Fiscale)
    also known as numéro fiscal de référence or SPI (Simplification des
    Procédures d'Identification) is a 13-digit number issued by the French tax
    authorities to people for tax reporting purposes.

    More information:
    - https://ec.europa.eu/taxation_customs/tin/tinByCountry.html
    - https://fr.wikipedia.org/wiki/Numéro_d%27Immatriculation_Fiscale#France
*)

exception Invalid_checksum
(** Exception raised when the check digits are invalid. *)

exception Invalid_length
(** Exception raised when the number has an invalid length. *)

exception Invalid_format
(** Exception raised when the number has an invalid format. *)

exception Invalid_component
(** Exception raised when the first digit is not 0, 1, 2, or 3. *)

val compact : string -> string
(** Convert the number to the minimal representation. This strips the number
    of any valid separators and removes surrounding whitespace. *)

val calc_check_digits : string -> string
(** Calculate the check digits for the number (based on the first 10 digits). *)

val validate : string -> string
(** Check if the number is a valid NIF. Returns the normalized number if valid.
    Raises an exception if invalid. *)

val is_valid : string -> bool
(** Check if the number is a valid NIF. Returns false if invalid. *)

val format : string -> string
(** Reformat the number to the standard presentation format. *)
