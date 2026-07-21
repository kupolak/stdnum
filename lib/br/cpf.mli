(** CPF (Cadastro de Pessoas Físicas, Brazilian national identifier).

    The Cadastro de Pessoas Físicas is the Brazilian identification number
    assigned to individuals for tax purposes. The number consists of 11 digits
    and includes two check digits.

    More information:
    - https://en.wikipedia.org/wiki/Cadastro_de_Pessoas_Físicas

    Example:
    {[
      validate "390.533.447-05" (* returns "39053344705" *) format
        "23100299900" (* returns "231.002.999-00" *)
    ]} *)

exception Invalid_format
exception Invalid_length
exception Invalid_checksum

val compact : string -> string
(** [compact number] converts the number to the minimal representation by
    stripping separators (spaces, dots, hyphens) and removing surrounding
    whitespace. *)

val validate : string -> string
(** [validate number] checks if the number is a valid CPF. This checks the
    length and whether the check digit is correct. Returns the validated number
    in compact form.

    @raise Invalid_checksum if the check digits are incorrect *)

val validate_result : string -> (string, Tools.Error.t) result
(** Same as {!validate} but returns a [result] instead of raising exceptions. *)

val is_valid : string -> bool
(** [is_valid number] checks if the number is a valid CPF. Returns [true] if
    valid, [false] otherwise. *)

val format : string -> string
(** [format number] reformats the number to the standard presentation format
    (XXX.XXX.XXX-XX). *)
