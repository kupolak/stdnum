exception Invalid_format
exception Invalid_length
exception Invalid_component

val compact : string -> string
(** [compact number] converts the VATIN to its minimal representation, keeping
    the ISO 3166-1 alpha-2 prefix (uppercased) when present. *)

val validate : string -> string
(** [validate number] validates a VAT identification number by dispatching to
    the appropriate country-specific module based on the 2-letter prefix.
    May also validate numbers without a prefix if they match a supported
    country's format. *)

val is_valid : string -> bool
(** [is_valid number] returns true if [number] is a valid VATIN. *)
