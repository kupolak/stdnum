(** Japanese Corporate Number (法人番号, hōjin bangō).

    The Corporate Number is assigned by the Japanese National Tax Agency to
    identify government organs, public entities, registered corporations and
    other organisations. The number consists of 13 digits where the first digit
    is a non-zero check digit. *)

exception Invalid_length
exception Invalid_format
exception Invalid_checksum

val compact : string -> string
(** Convert the number to the minimal representation. This strips the
    number of any valid separators and removes surrounding whitespace. *)

val format : string -> string
(** Reformat the number to the standard presentation format. *)

val validate : string -> string
(** Check if the number is valid. This checks the length and check digit.
    Returns the compacted number if valid, raises an exception otherwise. *)

val is_valid : string -> bool
(** Check if the number is a valid CN. Returns true if valid,
    false otherwise. *)
