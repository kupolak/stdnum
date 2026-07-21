(** UPI (ISO 4914 Unique Product Identifier).

    The Unique Product Identifier (UPI) is a 12-character alphanumeric code used
    to identify over-the-counter (OTC) derivative products. It consists of the
    two-character prefix QZ, nine characters that identify the product, and one
    check character. Vowels and the letter Y are not used. The check character
    uses the ISO 7064 Mod 31, 30 algorithm.

    More information:
    - https://www.iso.org/standard/80506.html
    - https://www.anna-dsb.com/upi-/
    - https://zakon.rada.gov.ua/laws/show/z1549-21 *)

exception Invalid_format
exception Invalid_length
exception Invalid_component
exception Invalid_checksum

(** Exception raised when the UPI has an invalid component (e.g. wrong prefix).
*)

val compact : string -> string
(** Convert the UPI to its minimal representation. This strips spaces and
    removes surrounding whitespace. *)

val calc_check_digit : string -> string
(** Calculate the check character for the number. *)

val validate : string -> string
(** Check if the number provided is a valid UPI. This checks the length, format,
    prefix and check character.

    @raise Invalid_checksum if the checksum fails *)

val validate_result : string -> (string, Tools.Error.t) result
(** Same as {!validate} but returns a [result] instead of raising exceptions. *)

val is_valid : string -> bool
(** Check if the number provided is a valid UPI. *)
