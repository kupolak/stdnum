(** Slovak IČ DPH (IČ pre daň z pridanej hodnoty) validation.

    The IČ DPH (Identifikačné číslo pre daň z pridanej hodnoty) is a 10-digit
    number used for VAT purposes. It has a straightforward checksum.
*)

exception Invalid_length
(** Exception raised when the IČ DPH has an invalid length (not 10 digits). *)

exception Invalid_format
(** Exception raised when the IČ DPH contains non-digit characters or has
    invalid format (starts with 0, or third digit is not in {2,3,4,7,8,9}). *)

exception Invalid_checksum
(** Exception raised when the checksum is invalid (number mod 11 ≠ 0). *)

val compact : string -> string
(** Convert the number to the minimal representation. This strips the number
    of any valid separators (spaces, dashes), removes the "SK" prefix if present,
    and removes surrounding whitespace.

    Example: [compact "SK 202 274 96 19"] returns ["2022749619"] *)

val checksum : string -> int
(** Calculate the checksum. Returns the number modulo 11.
    A valid IČ DPH should have checksum 0. *)

val validate : string -> string
(** Check if the number is a valid IČ DPH. This checks the length, formatting,
    and checksum. Returns the normalized number if valid.

    @raise Invalid_length if the number is not 10 digits
    @raise Invalid_format if the number contains non-digit characters, starts
           with 0, or the third digit is not in {2,3,4,7,8,9}
    @raise Invalid_checksum if the checksum (number mod 11) is not 0 *)

val is_valid : string -> bool
(** Check if the number is a valid IČ DPH. Returns [true] if valid, [false] otherwise. *)
