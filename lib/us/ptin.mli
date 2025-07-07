(*
PTIN (U.S. Preparer Tax Identification Number).

A Preparer Tax Identification Number (PTIN) is a unique identifier required
by the Internal Revenue Service for all paid federal tax return preparers.
*)

exception Invalid_format

val validate : string -> string
(** Check if the number is a valid PTIN. *)

val is_valid : string -> bool
(** Check if the number is a valid PTIN. *)

val format : string -> string
(** Reformat the number to the standard presentation format. *)
