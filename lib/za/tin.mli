(*
TIN (South African Tax Identification Number).

The South African Tax Identification Number (TIN or Tax Reference Number) is
issued to individuals and legal entities for tax purposes. The number
consists of 10 digits.

More information:

* https://www.oecd.org/tax/automatic-exchange/crs-implementation-and-assistance/tax-identification-numbers/South-Africa-TIN.pdf
* https://www.sars.gov.za/
*)

exception Invalid_format
exception Invalid_length
exception Invalid_component
exception Invalid_checksum

val compact : string -> string
(** Convert the number to the minimal representation.
    This strips the number of any valid separators and removes surrounding whitespace. *)

val validate : string -> string
(** Check if the number is a valid South Africa Tax Reference Number.
    This checks the length, formatting and check digit. *)

val is_valid : string -> bool
(** Check if the number is a valid South Africa Tax Reference Number. *)

val format : string -> string
(** Reformat the number to the standard presentation format. *)
