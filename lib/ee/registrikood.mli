(** Registrikood (Estonian organisation registration code).

    All organisations are assigned a unique tax identification code from the
    commercial register, from the state register or from the non-profit
    associations and foundations register. The code consists of 8 digits.

    Commercial company numbers start with a 1, schools and government numbers
    with a 7, non-profit organisations with an 8 and foundations with a 9. The
    number uses the same check digit algorithm as the Isikukood although that
    fact is undocumented.

    More information:
    - https://ariregister.rik.ee/
    - https://mtr.mkm.ee/ *)

exception Invalid_format
exception Invalid_length
exception Invalid_component
exception Invalid_checksum

val compact : string -> string
(** Convert the number to the minimal representation. This strips the number of
    any valid separators and removes surrounding whitespace. *)

val validate : string -> string
(** Check if the number provided is valid. This checks the length and check
    digit.

    @raise Invalid_checksum if the checksum fails *)

val validate_result : string -> (string, Tools.Error.t) result
(** Same as {!validate} but returns a [result] instead of raising exceptions. *)

val is_valid : string -> bool
(** Check if the number provided is valid. *)
