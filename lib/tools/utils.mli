val is_digits : string -> bool
(** [is_digits number] checks if all characters in [number] are digits. *)

val is_alpha : string -> bool
(** [is_alpha s] checks if all characters in [s] are alphabetic (A-Z, a-z). *)

val is_alnum : string -> bool
(** [is_alnum s] checks if all characters in [s] are alphanumeric (A-Z, a-z, 0-9). *)

val clean : string -> string -> string
(** [clean number deletechars] removes specified characters from [number]. *)
