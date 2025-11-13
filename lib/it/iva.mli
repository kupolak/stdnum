(** IVA (Imposta sul Valore Aggiunto, Italian VAT number).

    The IVA is an 11-digit number used to identify businesses in Italy.
    It consists of 10 digits followed by a check digit. *)

exception Invalid_format
exception Invalid_length
exception Invalid_checksum

val compact : string -> string
(** Remove any formatting characters from the number and return a clean string. *)

val calc_check_digit : string -> string
(** Calculate the check digit for the first 10 digits of an IVA number. *)

val validate : string -> string
(** Check if the given IVA number is valid.
    @raise Invalid_format if the number contains non-digit characters
    @raise Invalid_length if the number is not 11 digits
    @raise Invalid_checksum if the check digit is invalid *)

val is_valid : string -> bool
(** Check if the given IVA number is valid. *)
