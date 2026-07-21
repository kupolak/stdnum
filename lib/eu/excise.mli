(** European Excise Number

    The excise duty identification number assigned to businesses authorised to
    operate with excise goods (e.g. alcohol, tobacco, energy products, etc.).

    The number is issued by the national customs or tax authority of the Member
    State where the business is established. The number consists of a two-letter
    country code followed by up to 13 alphanumeric characters.

    More information:
    - https://ec.europa.eu/taxation_customs/dds2/seed/ *)

exception Invalid_format
exception Invalid_length
exception Invalid_component
exception Invalid_checksum

val compact : string -> string
(** Convert the number to the minimal representation. This strips the number of
    any valid separators and removes surrounding whitespace. *)

val validate : string -> string
(** Check if the number is a valid Excise number.

    @raise Invalid_component if the country code is not in the EU *)

val validate_result : string -> (string, Tools.Error.t) result
(** Same as {!validate} but returns a [result] instead of raising exceptions. *)

val is_valid : string -> bool
(** Check if the number is a valid Excise number. *)
