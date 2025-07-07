(*
SSN (U.S. Social Security Number).

A Social Security Number (SSN) is a nine-digit number issued to U.S. citizens,
permanent residents, and temporary (working) residents under section 205(c)(2)
of the Social Security Act.
*)

exception Invalid_format

val validate : string -> string
(** Check if the number is a valid SSN. *)

val is_valid : string -> bool
(** Check if the number is a valid SSN. *)

val format : string -> string
(** Reformat the number to the standard presentation format. *)
