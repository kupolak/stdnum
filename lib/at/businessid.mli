(** Austrian Company Register Numbers.

    The Austrian company register number consist of digits followed by a single
    letter, e.g. "122119m". Sometimes it is presented with preceding "FN", e.g.
    "FN 122119m". *)

exception Invalid_format
(** Exception raised when the Company Register Number has invalid format. *)

val compact : string -> string
(** Convert the number to the minimal representation. This strips the
    number of any valid separators and removes surrounding whitespace.
    Preceding "FN" is also removed. *)

val validate : string -> string
(** Check if the number is a valid company register number. This only
    checks the formatting.

    @raise Invalid_format if the number is improperly formatted *)

val is_valid : string -> bool
(** Check if the number is a valid company register number. *)
