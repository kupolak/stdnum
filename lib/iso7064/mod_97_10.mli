(*
The ISO 7064 Mod 97, 10 algorithm.

The Mod 97, 10 algorithm evaluates the whole number as an integer which is
valid if the number modulo 97 is 1. As such it has two check digits.
*)

(* Exception raised when the checksum is invalid *)
exception Invalid_checksum

(* Exception raised when the format is invalid *)
exception Invalid_format

(* Convert a base36 number to base10 *)
val to_base10 : string -> string

(* Calculate the checksum of a number *)
val checksum : string -> int

(* Calculate the extra digits that should be appended to the number to make it a valid number *)
val calc_check_digits : string -> string

(* Check whether the check digit is valid *)
val validate : string -> string

(* Check whether the number is valid *)
val is_valid : string -> bool
