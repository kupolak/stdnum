(** Postleitzahl (Austrian postal code).

    The Austrian postal code consists of four digits that identifies a post
    office in Austria.

    More information:
    - https://en.wikipedia.org/wiki/Postal_codes_in_Austria
    - https://www.post.at/suche/standortsuche.php/index/selectedsearch/plz *)

exception Invalid_format
exception Invalid_length
exception Invalid_component

val compact : string -> string
(** Convert the number to the minimal representation. This strips the number of
    any valid separators and removes surrounding whitespace. *)

val validate : string -> string
(** Check if the number is a valid postal code. *)

val validate_result : string -> (string, Tools.Error.t) result
(** Same as {!validate} but returns a [result] instead of raising exceptions. *)

val is_valid : string -> bool
(** Check if the number is a valid postal code. *)
