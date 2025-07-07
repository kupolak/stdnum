(*
RIF (Registro de Identificación Fiscal, Venezuelan VAT number).

The Registro de Identificación Fiscal (RIF) is the Venezuelan fiscal
registration number. The number consists of 10 digits where the first digit
denotes the type of number (person, company or government) and the last digit
is a check digit.
*)

exception Invalid_length
exception Invalid_format
exception Invalid_component
exception Invalid_checksum

val compact : string -> string
(** [compact number] converts the number to the minimal representation.
    This strips the number of any valid separators and removes surrounding
    whitespace. *)

val calc_check_digit : string -> string
(** [calc_check_digit number] calculates the check digit for the RIF. *)

val validate : string -> string
(** [validate number] checks if the number provided is a valid RIF.
    This checks the length, formatting and check digit. *)

val is_valid : string -> bool
(** [is_valid number] checks if the number provided is a valid RIF.
    This checks the length, formatting and check digit. *)
