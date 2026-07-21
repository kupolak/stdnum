(*
Czech bank account number.

The Czech bank account numbers consist of up to 20 digits:
    UUUUUK-MMMMMMMMKM/XXXX

The first part is prefix that is up to 6 digits. The following part is from 2 to 10 digits.
Both parts could be filled with zeros from left if missing.
The final 4 digits represent the bank code.

More information:

* https://www.penize.cz/osobni-ucty/424173-tajemstvi-cisla-uctu-klicem-pro-banky-je-11
* https://www.zlatakoruna.info/zpravy/ucty/cislo-uctu-v-cr
*)

exception Invalid_length
exception Invalid_format
exception Invalid_checksum
exception Invalid_bank

val validate : string -> string
(** Check if the number is a valid Czech bank account number. Returns the
    normalized number if valid. if the number contains non-digit characters or
    invalid format
    @raise Invalid_bank if the bank code is invalid *)

val validate_result : string -> (string, Tools.Error.t) result
(** Same as {!validate} but returns a [result] instead of raising exceptions. *)

val is_valid : string -> bool
(** Check if the number is a valid Czech bank account number. Returns true if
    valid, false otherwise. *)

val format : string -> string
(** Reformat the number to the standard presentation format with proper padding.
*)

val compact : string -> string
(** [compact number] removes spaces and normalizes the number with proper
    padding. *)

val calc_checksum : string -> int
(** [calc_checksum number] calculates the checksum for the given number sequence
    using the Czech bank account algorithm. Returns 0 for valid numbers. *)
