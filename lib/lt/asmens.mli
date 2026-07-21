(** Asmens kodas (Lithuanian, personal numbers).

    The Asmens kodas consists of 11 digits. The first digits denotes the gender
    and birth century, the second through seventh denotes the birth date,
    followed by a three-digit serial and a check digit.

    More information:
    - https://lt.wikipedia.org/wiki/Asmens_kodas
    - https://en.wikipedia.org/wiki/National_identification_number#Lithuania *)

exception Invalid_format
exception Invalid_length
exception Invalid_component
exception Invalid_checksum

val compact : string -> string
(** Convert the number to the minimal representation. This strips the number of
    any valid separators and removes surrounding whitespace. *)

val validate : ?validate_birth_date:bool -> string -> string
(** Check if the number provided is valid. This checks the length, formatting,
    embedded date and check digit.

    @raise Invalid_checksum if the checksum fails *)

val validate_result :
  ?validate_birth_date:bool -> string -> (string, Tools.Error.t) result
(** Same as {!validate} but returns a [result] instead of raising exceptions. *)

val is_valid : ?validate_birth_date:bool -> string -> bool
(** Check if the number provided is valid. This checks the length, formatting,
    embedded date and check digit. *)
