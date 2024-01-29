(*
NIPT, NUIS (Numri i Identifikimit për Personin e Tatueshëm, Albanian tax number).

The Albanian NIPT is a 10-digit number with the first and last character
being letters. The number is assigned to individuals and organisations for
tax purposes.

The first letter indicates the decade the number was assigned or date birth
date for individuals, followed by a digit for the year. The next two digits
contain the month (and gender for individuals and region for organisations)
followed by two digits for the day of the month. The remainder is a serial
followed by a check letter (check digit algorithm unknown).   
*)

exception Invalid_length
(** Exception raised when the NIPT number has an invalid length. *)

exception Invalid_format
(** Exception raised when the NIPT number has an invalid format. *)

val nipt_re : Str.regexp

val compact : string -> string
(** [compact number] removes spaces and converts [number] to uppercase. *)

val validate : string -> string
(** [validate number] checks if [number] is a valid NIPT number.
    It raises [Invalid_length] or [Invalid_format] if the number is not valid. *)

val is_valid : string -> bool
(** [is_valid number] checks if [number] is a valid NIPT number.
    It returns [true] if the number is valid, [false] otherwise. *)
