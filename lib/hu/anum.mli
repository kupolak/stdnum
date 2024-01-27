(*
ANUM (Közösségi adószám, Hungarian VAT number).

The ANUM is the Hungarian VAT (Közösségi adószám) number. It is an 8-digit
taxpayer registration number that includes a weighted checksum.
*)

exception Invalid_format
exception Invalid_length
exception Invalid_checksum

val compact : string -> string
(** [compact number] converts the number to the minimal representation. *)

val checksum : string -> int
(** [checksum number] calculates the checksum. Valid numbers should have a checksum of 0. *)

val validate : string -> string
(** [validate number] checks if the number is a valid VAT number. *)

val is_valid : string -> bool
(** [is_valid number] checks if the number provided is a valid VAT number. *)
