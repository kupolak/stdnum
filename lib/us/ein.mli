(*
EIN (U.S. Employer Identification Number).

An Employer Identification Number (EIN) is a unique nine-digit number assigned
by the Internal Revenue Service to businesses operating in the United States
for the purposes of identification.
*)

exception Invalid_format

val validate : string -> string
(** Check if the number is a valid EIN. *)

val validate_result : string -> (string, Tools.Error.t) result
(** Same as {!validate} but returns a [result] instead of raising exceptions. *)

val is_valid : string -> bool
(** Check if the number is a valid EIN. *)

val format : string -> string
(** Reformat the number to the standard presentation format. *)
