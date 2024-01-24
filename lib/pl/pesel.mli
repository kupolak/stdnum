(*
   PESEL (Polish national identification number).

   The Powszechny Elektroniczny System Ewidencji Ludności (PESEL, Universal
   Electronic System for Registration of the Population) is an 11-digit Polish
   national identification number. The number consists of the date of birth,
   a serial number, the person's gender, and a check digit.
*)

exception Invalid_component
(** Exception raised for an invalid component in the PESEL. *)

exception Invalid_length
(** Exception raised for an invalid length in the PESEL. *)

exception Invalid_checksum
(** Exception raised for an invalid checksum in the PESEL. *)

exception Invalid_format
(** Exception raised for an invalid format in the PESEL. *)

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

val is_valid : string -> bool
(** Check if the PESEL number is valid. *)
