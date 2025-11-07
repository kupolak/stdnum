(** Slovenian Matična številka poslovnega registra (Corporate Registration Number).

    The Corporate registration number represents a unique identification of each
    unit of the business register. The number consists of 7 or 10 digits and
    includes a check digit.

    Structure:
    - First 6 digits: unique number for each unit/company
    - 7th digit: check digit
    - Last 3 digits (optional): business unit number (starting at 001)
      When a company has more than 1000 units, a letter replaces the first digit.
      Unit 000 always represents the main registered address.
*)

exception Invalid_length
(** Exception raised when the number has an invalid length (not 7 or 10 digits). *)

exception Invalid_format
(** Exception raised when the number contains invalid characters or format. *)

exception Invalid_checksum
(** Exception raised when the check digit is invalid. *)

val compact : string -> string
(** Convert the number to the minimal representation. This strips spaces and
    periods, and if the number ends with "000" (main unit), returns only the
    first 7 digits.

    Example: [compact "9331310000"] returns ["9331310"] *)

val calc_check_digit : string -> string
(** Calculate the check digit for the first 6 digits using weights [7,6,5,4,3,2].
    Returns "invalid" if the calculated remainder is 0, otherwise returns the
    check digit as a string. *)

val validate : string -> string
(** Check if the number is a valid Corporate Registration number. This checks
    the length, format, and check digit. Returns the normalized number if valid.

    @raise Invalid_length if the number is not 7 or 10 digits
    @raise Invalid_format if the first 6 digits are not numeric, or if the
           business unit (last 3 chars when length is 10) doesn't match the
           pattern [A-Z0-9][0-9]{2}
    @raise Invalid_checksum if the check digit is invalid or if the calculated
           remainder is 0 *)

val is_valid : string -> bool
(** Check if the number is a valid Corporate Registration number.
    Returns [true] if valid, [false] otherwise. *)
