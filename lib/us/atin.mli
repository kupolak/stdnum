(*
ATIN (U.S. Adoption Taxpayer Identification Number).

An Adoption Taxpayer Identification Number (ATIN) is a temporary
nine-digit number issued by the United States IRS for a child for whom the
adopting parents cannot obtain a Social Security Number.
*)

exception Invalid_format

val atin_re : Str.regexp
(** Regular expression for matching ATINs *)

val validate : string -> string
(** Check if the number is a valid ATIN.
    This checks the length and formatting if it is present. *)

val is_valid : string -> bool
(** Check if the number is a valid ATIN. *)

val format_number : string -> string
(** Reformat the number to the standard presentation format. *)
