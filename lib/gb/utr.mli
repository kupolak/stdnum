(** UTR (United Kingdom Unique Taxpayer Reference).

    A UTR (unique taxpayer reference) is a 10 digit number used to identify UK
    taxpayers who have to submit a tax return.

    More information:
    - https://www.oecd.org/tax/automatic-exchange/crs-implementation-and-assistance/tax-identification-numbers/UK-TIN.pdf
*)

exception Invalid_format
exception Invalid_length
exception Invalid_checksum

val compact : string -> string
(** Convert the number to the minimal representation. This strips the number of
    any valid separators and removes surrounding whitespace. *)

val calc_check_digit : string -> string
(** Calculate the check digit for the number. The passed number should not have
    the check digit (the first one) included. *)

val validate : string -> string
(** Check if the number is a valid UTR.

    @raise Invalid_checksum if the checksum fails *)

val validate_result : string -> (string, Tools.Error.t) result
(** Same as {!validate} but returns a [result] instead of raising exceptions. *)

val is_valid : string -> bool
(** Check if the number is a valid UTR. *)
