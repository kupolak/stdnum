(** VAT (Идентификационен номер по ДДС, Bulgarian VAT number).

    The Bulgarian VAT (Данък върху добавената стойност) number is either 9
    (for legal entities) or 10 digits (for physical persons, foreigners and
    others) long. Each type of number has its own check digit algorithm.

    More information:
    - https://en.wikipedia.org/wiki/VAT_identification_number *)

exception Invalid_format
(** Exception raised when the VAT number has invalid format. *)

exception Invalid_length
(** Exception raised when the VAT number has invalid length. *)

exception Invalid_checksum
(** Exception raised when the checksum validation fails. *)

val compact : string -> string
(** Convert the number to the minimal representation. This strips the
    number of any valid separators and removes surrounding whitespace. *)

val validate : string -> string
(** Check if the number is a valid VAT number. This checks the length,
    formatting and check digit.

    @raise Invalid_format if the number contains invalid characters
    @raise Invalid_length if the length is invalid
    @raise Invalid_checksum if the checksum fails *)

val is_valid : string -> bool
(** Check if the number is a valid VAT number. *)
