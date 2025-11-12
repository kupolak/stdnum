(** Postcode (the Spanish postal code).

    The Spanish postal code consists of five digits where the first two digits,
    ranging 01 to 52, correspond either to one of the 50 provinces of Spain or to
    one of the two autonomous cities on the African coast. *)

exception Invalid_length
exception Invalid_format
exception Invalid_component

val compact : string -> string
(** Convert the number to the minimal representation. *)

val validate : string -> string
(** Check if the number provided is a valid postal code. Returns the compacted
    number if valid, raises an exception otherwise. *)

val is_valid : string -> bool
(** Check if the number provided is a valid postal code. Returns true if valid,
    false otherwise. *)
