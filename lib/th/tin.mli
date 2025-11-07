(*
TIN (Thailand Taxpayer Identification Number).

The Taxpayer Identification Number is used for tax purposes in the Thailand.
This number consists of 13 digits which the last is a check digit.

Personal income taxpayers use Personal Identification Number (PIN) while
companies use Memorandum of Association (MOA).
*)

exception Invalid_format

val compact : string -> string
(** Convert the number to the minimal representation. *)

val tin_type : string -> string option
(** Return a TIN type which this number is valid ("moa" or "pin"). *)

val validate : string -> string
(** Check if the number is a valid TIN. This searches for the proper
    sub-type and validates using that. *)

val is_valid : string -> bool
(** Check whether the number is valid. *)

val format : string -> string
(** Reformat the number to the standard presentation format. *)
