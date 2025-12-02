(** USCC (Unified Social Credit Code, 统一社会信用代码, China tax number).

    This number consists of 18 digits or uppercase English letters (excluding
    the letters I, O, Z, S, V). The number is comprised of several parts:

    - Digit 1 represents the registering authority,
    - Digit 2 represents the registered entity type,
    - Digits 3 through 8 represent the registering region code,
    - Digits 9 through 17 represent the organisation code,
    - Digit 18 is a check digit (either a number or letter).

    More information:
    - https://zh.wikipedia.org/wiki/统一社会信用代码
    - https://www.oecd.org/tax/automatic-exchange/crs-implementation-and-assistance/tax-identification-numbers/China-TIN.pdf *)

exception Invalid_format
(** Exception raised when the number format is invalid. *)

exception Invalid_length
(** Exception raised when the number length is invalid. *)

exception Invalid_checksum
(** Exception raised when the check digit is invalid. *)

val compact : string -> string
(** [compact number] converts the number to the minimal representation by
    stripping separators and whitespace. *)

val calc_check_digit : string -> string
(** [calc_check_digit number] calculates the check digit for a USCC number
    without the check digit. *)

val validate : string -> string
(** [validate number] checks if the number is a valid USCC number.
    Returns the validated number in compact form.

    @raise Invalid_length if the number length is not 18
    @raise Invalid_format if the first 8 characters are not digits or if
                          characters 9-18 contain invalid characters (I, O, Z, S, V)
    @raise Invalid_checksum if the check digit is invalid *)

val is_valid : string -> bool
(** [is_valid number] checks if the number is a valid USCC number.
    Returns [true] if valid, [false] otherwise. *)

val format : string -> string
(** [format number] reformats the number to the standard presentation format. *)
