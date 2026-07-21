(** EIC (European Energy Identification Code).

    The EIC (Energy Identification Code) a 16 character code used in Europe to
    uniquely identify entities and objects in the electricity and gas sector.

    The number uses letters, digits and the minus sign. The first 2 character
    identify the issuing office, 1 character for the object type, 12 digits for
    the object and 1 check character.

    More information:
    - https://en.wikipedia.org/wiki/Energy_Identification_Code
    - https://www.entsoe.eu/data/energy-identification-codes-eic/ *)

exception Invalid_format
exception Invalid_length
exception Invalid_checksum

val compact : string -> string
(** Convert the number to the minimal representation. This strips the number of
    any valid separators and removes surrounding white space. *)

val calc_check_digit : string -> string
(** Calculate the check digit for the number. *)

val validate : string -> string
(** Check if the number is valid. This checks the length, format and check
    digit.

    @raise Invalid_checksum if the checksum fails *)

val validate_result : string -> (string, Tools.Error.t) result
(** Same as {!validate} but returns a [result] instead of raising exceptions. *)

val is_valid : string -> bool
(** Check if the number is valid. *)
