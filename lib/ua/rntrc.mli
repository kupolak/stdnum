(*
   РНОКПП, RNTRC (Individual taxpayer registration number in Ukraine).

   The РНОКПП (Реєстраційний номер облікової картки платника податків,
   registration number of the taxpayer's registration card) is a unique
   identification number that is provided to individuals within Ukraine. The
   number consists of 10 digits, the last being a check digit.

   More information:
   * https://uk.wikipedia.org/wiki/РНОКПП
*)

exception Invalid_format
(** Exception raised for an invalid RNTRC format. *)

exception Invalid_length
(** Exception raised for an invalid RNTRC length. *)

exception Invalid_checksum
(** Exception raised for an invalid RNTRC checksum. *)

val compact : string -> string
(** [compact number] converts the RNTRC number to its minimal representation.
    @param number The RNTRC number.
    @return The compacted RNTRC number. *)

val calc_check_digit : string -> string
(** [calc_check_digit number] calculates the check digit for the RNTRC number.
    @param number The RNTRC number (first 9 digits).
    @return The check digit as a string. *)

val validate : string -> string
(** [validate number] checks if the RNTRC number is valid.
    @param number The RNTRC number to validate.
    @return The compacted RNTRC number if valid.
    @raises Invalid_format if the format is invalid.
    @raises Invalid_length if the length is invalid.
    @raises Invalid_checksum if the checksum is invalid. *)

val is_valid : string -> bool
(** [is_valid number] checks if the RNTRC number is valid.
    @param number The RNTRC number to check.
    @return true if the RNTRC number is valid, false otherwise. *)

val format : string -> string
(** [format number] reformats the RNTRC number to the standard presentation format.
    @param number The RNTRC number.
    @return The formatted RNTRC number. *)
