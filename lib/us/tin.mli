(*
TIN (U.S. Taxpayer Identification Number).

The Taxpayer Identification Number is used for tax purposes in the
United States. A TIN may be:

* a Social Security Number (SSN)
* an Individual Taxpayer Identification Number (ITIN)
* an Employer Identification Number (EIN)
* a Preparer Tax Identification Number (PTIN)
* an Adoption Taxpayer Identification Number (ATIN)
*)

exception Invalid_format

val compact : string -> string
(** Convert the number to the minimal representation. This strips the
    number of any valid separators and removes surrounding whitespace. *)

val validate : string -> string
(** Check if the number is a valid TIN. This searches for the proper
    sub-type and validates using that. *)

val is_valid : string -> bool
(** Check if the number is a valid TIN. *)

val guess_type : string -> string list
(** Return a list of possible TIN types for which this number is valid. *)

val format : string -> string
(** Reformat the number to the standard presentation format. *)
