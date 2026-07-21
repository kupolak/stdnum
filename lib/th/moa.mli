(*
MOA (Thailand Memorandum of Association Number).

Memorandum of Association Number (aka Company's Taxpayer Identification
Number) are numbers issued by the Department of Business Development.

The number consists of 13 digits of which the last is a check digit following
the same algorithm as in the Personal Identity Number (PIN). It uses a
different grouping format and always starts with zero to indicate that the
number issued by DBD.

More information:

* https://www.dbd.go.th/download/pdf_kc/s09/busin_2542-48.pdf
*)

exception Invalid_length
exception Invalid_format
exception Invalid_component
exception Invalid_checksum

val compact : string -> string
(** Convert the number to the minimal representation. This strips the number of
    any valid separators and removes surrounding whitespace. *)

val calc_check_digit : string -> string
(** Calculate the check digit for the first 12 digits. Uses the same algorithm
    as PIN. *)

val validate : string -> string
(** Check if the number is a valid MOA Number. This checks the length,
    formatting, component and check digit. Returns the normalized number if
    valid.
    @raise Invalid_checksum if the check digit is invalid *)

val validate_result : string -> (string, Tools.Error.t) result
(** Same as {!validate} but returns a [result] instead of raising exceptions. *)

val is_valid : string -> bool
(** Check whether the number is valid. Returns true if valid, false otherwise.
*)

val format : string -> string
(** Reformat the number to the standard presentation format
    (0-XX-X-XXX-XXXXX-X). *)
