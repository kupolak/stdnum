(*
T.C. Kimlik No. (Turkish personal identification number)

The Turkish Identification Number (Türkiye Cumhuriyeti Kimlik Numarası) is a
unique personal identification number assigned to every citizen of Turkey.
The number consists of 11 digits and the last two digits are check digits.

More information:

* https://en.wikipedia.org/wiki/Turkish_Identification_Number
* https://tckimlik.nvi.gov.tr/
*)

exception Invalid_format
(** Exception raised when the number has an invalid format. *)

exception Invalid_length
(** Exception raised when the number has an invalid length. *)

exception Invalid_checksum
(** Exception raised when the check digits are invalid. *)

val validate : string -> string
(** Check if the number is a valid T.C. Kimlik number. This checks the
    length and check digits. Returns the normalized number if valid.
    @raise Invalid_format if the number contains non-digits or starts with 0
    @raise Invalid_length if the number length is not 11
    @raise Invalid_checksum if the check digits are invalid *)

val is_valid : string -> bool
(** Check if the number is a valid T.C. Kimlik number.
    Returns true if valid, false otherwise. *)

val format : string -> string
(** Reformat the number to the minimal representation. *)

val compact : string -> string
(** [compact number] removes spaces and dashes from the number. *)

val calc_check_digits : string -> string
(** [calc_check_digits number] calculates the two check digits for the given 9-digit number.
    The number passed should not have the check digits included. *)
