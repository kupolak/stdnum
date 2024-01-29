(*
NRT (Número de Registre Tributari, Andorra tax number).

The Número de Registre Tributari (NRT) is an identifier of legal and natural
entities for tax purposes.

This number consists of one letter indicating the type of entity, then 6
digits, followed by a check letter.
*)

exception Invalid_length
exception Invalid_format
exception Invalid_component

val isdigits : string -> bool
(* Check if the string is a valid integer. *)

val is_alpha : char -> bool
(* Check if the character is an alphabetic character. *)

val validate : string -> string
(* Check if the number is a valid Andorra NRT number. This checks the length, formatting and other constraints. It does not check for control letter. *)

val is_valid : string -> bool
(* Check if the number is a valid Andorra NRT number. *)

val format : string -> string
(* Reformat the number to the standard presentation format. *)
