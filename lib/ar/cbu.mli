(*
CBU (Clave Bancaria Uniforme, Argentine bank account number).

CBU it s a code of the Banks of Argentina to identify customer accounts. The
number consists of 22 digits and consists of a 3 digit bank identifier,
followed by a 4 digit branch identifier, a check digit, a 13 digit account
identifier and another check digit.

More information:

* https://es.wikipedia.org/wiki/Clave_Bancaria_Uniforme
*)

exception Invalid_length
exception Invalid_format
exception Invalid_checksum

val validate : string -> string
(** Check if the number is a valid CBU. Returns the normalized number if valid.
    @raise Invalid_checksum if either check digit is invalid *)

val validate_result : string -> (string, Tools.Error.t) result
(** Same as {!validate} but returns a [result] instead of raising exceptions. *)

val is_valid : string -> bool
(** Check if the number is a valid CBU. Returns true if valid, false otherwise.
*)

val format : string -> string
(** Reformat the number to the standard presentation format with spaces. *)

val compact : string -> string
(** [compact number] removes spaces and dashes from the number. *)

val calc_check_digit : string -> string
(** [calc_check_digit number] calculates the check digit for the given number
    sequence using the CBU algorithm. *)
