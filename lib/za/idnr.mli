(*
IDNR (South African Identity Document number).

The South African ID number is issued to individuals within South Africa. The
number consists of 13 digits and contains information about a person's date of
birth, gender and whether the person is a citizen or permanent resident.

More information:

* https://en.wikipedia.org/wiki/South_African_identity_card
* https://www.dha.gov.za/index.php/identity-documents2
*)

exception Invalid_format
exception Invalid_length
exception Invalid_checksum
exception Invalid_component

val compact : string -> string
(** Convert the number to the minimal representation. This strips the number of
    any valid separators and removes surrounding whitespace. *)

val validate : string -> string
(** Check if the number is a valid South African ID number. This checks the
    length, formatting and check digit. *)

val validate_result : string -> (string, Tools.Error.t) result
(** Same as {!validate} but returns a [result] instead of raising exceptions. *)

val is_valid : string -> bool
(** Check if the number is a valid South African ID number. *)

val format : string -> string
(** Reformat the number to the standard presentation format. *)

val get_birth_date : string -> (float * Unix.tm) option
(** Split the date parts from the number and return the date of birth. Since the
    number only uses two digits for the year, the century may be incorrect. *)

val get_gender : string -> char
(** Get the gender (M/F) from the person's ID number. *)

val get_citizenship : string -> string
(** Get the citizenship status (citizen/resident) from the ID number. *)
