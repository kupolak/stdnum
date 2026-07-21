(*
   PESEL (Polish national identification number).

   The Powszechny Elektroniczny System Ewidencji Ludności (PESEL, Universal
   Electronic System for Registration of the Population) is an 11-digit Polish
   national identification number. The number consists of the date of birth,
   a serial number, the person's gender, and a check digit.
*)

exception Invalid_component
exception Invalid_length
exception Invalid_checksum
exception Invalid_format

val compact : string -> string
(** Compact the PESEL number by removing separators and trimming. *)

val get_birth_date : string -> (float * Unix.tm) option
(** Get the birth date from the PESEL number. *)

val get_gender : string -> char
(** Get the gender from the PESEL number. *)

val calc_check_digit : string -> string
(** Calculate the check digit for the PESEL number. *)

val validate : string -> string
(** Validate the PESEL number, checking length, format, and checksum. *)

val validate_result : string -> (string, Tools.Error.t) result
(** Same as {!validate} but returns a [result] instead of raising exceptions. *)

val is_valid : string -> bool
(** Check if the PESEL number is valid. *)
