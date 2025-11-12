(** CAE (Código de Actividad y Establecimiento, Spanish activity establishment code).

    The Código de Actividad y Establecimiento (CAE) is assigned by the Spanish
    Tax Agency to companies or establishments that carry out activities related to
    products subject to excise duty. It identifies an activity and the
    establishment in which it is carried out.

    The number consists of 13 characters where the sixth and seventh characters
    identify the managing office in which the territorial registration is carried
    out and the eighth and ninth characters identify the activity that takes
    place. *)

exception Invalid_length
exception Invalid_format

val compact : string -> string
(** Convert the number to the minimal representation. This strips the
    number of any valid separators and removes surrounding whitespace. *)

val validate : string -> string
(** Check if the number provided is a valid CAE number. This checks the
    length and formatting. Returns the compacted number if valid,
    raises an exception otherwise. *)

val is_valid : string -> bool
(** Check if the number provided is a valid CAE number. Returns true if valid,
    false otherwise. *)
