(*
   REGON (Rejestr Gospodarki Narodowej, Polish register of economic units).

   The REGON (Rejestr Gospodarki Narodowej) is a statistical identification
   number for businesses. National entities are assigned a 9-digit number, while
   local units append 5 digits to form a 14-digit number.
*)

exception Invalid_format
exception Invalid_length
exception Invalid_checksum

val compact : string -> string
(** [compact number] converts the REGON number to minimal representation. *)

val calc_check_digit : string -> string
(** [calc_check_digit number] calculates the check digit for a REGON number. *)

val validate : string -> string
(** [validate number] checks if the REGON number is valid (length, format,
    checksum). *)

val validate_result : string -> (string, Tools.Error.t) result
(** Same as {!validate} but returns a [result] instead of raising exceptions. *)

val is_valid : string -> bool
(** [is_valid number] checks if the REGON number is a valid REGON number. *)
