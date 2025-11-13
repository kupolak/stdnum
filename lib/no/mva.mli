(** MVA (Merverdiavgift, Norwegian VAT number).

    The VAT number is the standard Norwegian organisation number
    (Organisasjonsnummer) with 'MVA' as suffix. *)

exception Invalid_format

val compact : string -> string
(** Convert the number to the minimal representation. This strips the
    number of any valid separators and removes surrounding whitespace. *)

val validate : string -> string
(** Check if the number is a valid MVA number. This checks the length,
    formatting and check digit.
    Raises Invalid_format or Orgnr exceptions if invalid. *)

val is_valid : string -> bool
(** Check if the number is a valid MVA number. *)

val format : string -> string
(** Reformat the number to the standard presentation format (NO XXX XXX XXX MVA). *)
