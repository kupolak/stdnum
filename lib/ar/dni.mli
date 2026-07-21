(** DNI (Documento Nacional de Identidad, Argentinian national identity nr.).

    The DNI number is the number that appears on the Argentinian national
    identity document and is used to identify citizen and foreigners residing in
    the country.

    More information:
    - https://en.wikipedia.org/wiki/Documento_Nacional_de_Identidad_(Argentina)
*)

exception Invalid_format
exception Invalid_length

val compact : string -> string
(** Convert the number to the minimal representation. This strips the number of
    any valid separators and removes surrounding whitespace. *)

val validate : string -> string
(** Check if the number is a valid DNI.

    @raise Invalid_length if the length is not 7 or 8 *)

val validate_result : string -> (string, Tools.Error.t) result
(** Same as {!validate} but returns a [result] instead of raising exceptions. *)

val is_valid : string -> bool
(** Check if the number is a valid DNI. *)

val format : string -> string
(** Reformat the number to the standard presentation format. *)
