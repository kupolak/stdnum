(** Czech DIČ (Daňové identifikační číslo, VAT number).

    The DIČ is an 8, 9 or 10 digit code used to uniquely identify taxpayers for
    VAT (DPH in Czech). The number can refer to:
    - Legal entities: 8 digit numbers with a check digit
    - Individuals with a RČ: 9 or 10 digit Czech birth number
    - Individuals without a RČ: 9 digit numbers beginning with 6 (special case)

    Examples:
    - Legal entity: 25123891
    - Individual with RČ: 7103192745
    - Special case: 640903926 *)

exception Invalid_length
exception Invalid_format
exception Invalid_checksum
exception Invalid_component

(** Exception raised when the number has invalid components (e.g., 8-digit
    number starting with 9). *)

val compact : string -> string
(** Convert the number to the minimal representation. This strips the number of
    any valid separators, removes the 'CZ' prefix if present, and removes
    surrounding whitespace.

    Example: [compact "CZ 25123891"] returns ["25123891"] *)

val calc_check_digit_legal : string -> string
(** Calculate the check digit for 8 digit legal entities. The number passed
    should not have the check digit included (7 digits).

    Example: [calc_check_digit_legal "2512389"] returns ["1"] *)

val calc_check_digit_special : string -> string
(** Calculate the check digit for special cases (9-digit numbers starting with
    6). The number passed should not have the first and last digits included (7
    digits).

    Example: [calc_check_digit_special "4090392"] returns ["6"] *)

val validate : string -> string
(** Check if the number is a valid VAT number. This checks the length,
    formatting and check digit. Returns the normalized number if valid.

    @raise Invalid_component if the number has invalid components *)

val validate_result : string -> (string, Tools.Error.t) result
(** Same as {!validate} but returns a [result] instead of raising exceptions. *)

val is_valid : string -> bool
(** Check if the number is a valid VAT number. Returns [true] if valid, [false]
    otherwise. *)
