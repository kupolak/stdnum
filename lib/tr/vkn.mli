(*
VKN (Vergi Kimlik Numarası, Turkish tax identification number).

The Vergi Kimlik Numarası is the Turkish tax identification number used for
businesses. The number consists of 10 digits where the first digit is derived
from the company name.

More information:
* https://www.turkiye.gov.tr/gib-intvrg-vergi-kimlik-numarasi-dogrulama
*)

exception Invalid_format
(** Exception raised when the VKN number has an invalid format. *)

exception Invalid_length
(** Exception raised when the VKN number has an invalid length. *)

exception Invalid_checksum
(** Exception raised when the VKN number has an invalid checksum. *)

val compact : string -> string
(** [compact number] converts the number to the minimal representation. 
    This strips the number of any valid separators and removes surrounding whitespace. *)

val calc_check_digit : string -> string
(** [calc_check_digit number] calculates the check digit for the specified number. *)

val validate : string -> string
(** [validate number] checks if the number is a valid Vergi Kimlik Numarası. 
    This checks the length and check digits. *)

val is_valid : string -> bool
(** [is_valid number] checks if the number is a valid Vergi Kimlik Numarası. 
    This checks the length and check digits. *)
