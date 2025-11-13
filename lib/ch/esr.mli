(** ESR, ISR, QR-reference (reference number on Swiss payment slips).

    The ESR (Eizahlungsschein mit Referenznummer), ISR (In-payment Slip with
    Reference Number) or QR-reference refers to the orange payment slip in
    Switzerland with which money can be transferred to an account.

    The number consists of 26 numerical characters followed by a Modulo 10
    recursive check digit. It is printed in blocks of 5 characters (beginning
    with 2 characters, then 5x5-character groups). Leading zeros digits can be
    omitted.

    More information:
    - https://www.paymentstandards.ch/dam/downloads/ig-qr-bill-en.pdf *)

exception Invalid_format
exception Invalid_length
exception Invalid_checksum

val compact : string -> string
(** Remove surrounding whitespace, separators, and leading zeros. *)

val calc_check_digit : string -> string
(** Calculate the check digit for number. The number passed should
    not have the check digit included. *)

val validate : string -> string
(** Check if the number is a valid ESR. This checks the length, formatting
    and check digit.
    @raise Invalid_length if the number is longer than 27 digits
    @raise Invalid_format if the number contains non-digit characters
    @raise Invalid_checksum if the check digit is invalid *)

val is_valid : string -> bool
(** Check if the number is a valid ESR. *)

val format : string -> string
(** Reformat the number to the standard presentation format (XX XXXXX XXXXX XXXXX XXXXX XXXXX). *)
