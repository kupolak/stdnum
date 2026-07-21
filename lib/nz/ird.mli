(** IRD number (New Zealand Inland Revenue Department (Te Tari Tāke) number).

    The IRD number is used by the New Zealand Inland Revenue Department (Te Tari
    Tāke in Māori) to identify businesses and individuals for tax purposes. The
    number consists of 8 or 9 digits where the last digit is a check digit.

    More information:
    - https://www.ird.govt.nz/
    - https://www.ird.govt.nz/-/media/Project/IR/PDF/2020RWTNRWTSpecificationDocumentv10.pdf
    - https://www.oecd.org/tax/automatic-exchange/crs-implementation-and-assistance/tax-identification-numbers/New%20Zealand-TIN.pdf
*)

exception Invalid_format
(** Exception raised when the number has invalid format. *)

exception Invalid_length
(** Exception raised when the number has invalid length. *)

exception Invalid_checksum
(** Exception raised when the checksum validation fails. *)

exception Invalid_component
(** Exception raised when a component of the number is invalid. *)

val compact : string -> string
(** Convert the number to the minimal representation. *)

val calc_check_digit : string -> string
(** Calculate the check digit. The number passed should not have the check digit
    included. *)

val validate : string -> string
(** Check if the number is a valid IRD number.

    @raise Invalid_format if the number contains invalid characters
    @raise Invalid_length if the length is not 8 or 9
    @raise Invalid_checksum if the checksum fails
    @raise Invalid_component if the number is out of the valid range *)

val is_valid : string -> bool
(** Check if the number is a valid IRD number. *)

val format : string -> string
(** Reformat the number to the standard presentation format. *)
