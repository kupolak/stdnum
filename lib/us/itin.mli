(*
ITIN (U.S. Individual Taxpayer Identification Number).

An Individual Taxpayer Identification Number (ITIN) is a United States federal
tax processing number issued by the Internal Revenue Service to individuals
who are required to have a U.S. taxpayer identification number but who do not
have, and are not eligible to obtain, a Social Security Number.
*)

exception Invalid_format

val validate : string -> string
(** Check if the number is a valid ITIN. *)

val is_valid : string -> bool
(** Check if the number is a valid ITIN. *)

val format : string -> string
(** Reformat the number to the standard presentation format. *)
