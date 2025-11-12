(** Referencia Catastral (Spanish real estate property id).

    The cadastral reference code is an identifier for real estate in Spain. It is
    issued by Dirección General del Catastro (General Directorate of Land
    Registry) of the Ministerio de Hacienda (Treasury Ministry).

    It has 20 digits and contains numbers and letters including the Spanish Ñ.
    The number consists of 14 digits for the parcel, 4 for identifying properties
    within the parcel and 2 check digits. The parcel digits are structured
    differently for urban, non-urban or special (infrastructure) cases. *)

exception Invalid_length
exception Invalid_format
exception Invalid_checksum

val compact : string -> string
(** Convert the number to the minimal representation. This strips the
    number of any valid separators and removes surrounding whitespace. *)

val format : string -> string
(** Reformat the number to the standard presentation format. *)

val calc_check_digits : string -> string
(** Calculate the check digits for the number. *)

val validate : string -> string
(** Check if the number is a valid Cadastral Reference. This checks the
    length, formatting and check digits. Returns the compacted number if valid,
    raises an exception otherwise. *)

val is_valid : string -> bool
(** Check if the number is a valid Cadastral Reference. Returns true if valid,
    false otherwise. *)
