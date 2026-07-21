(*
PIN (Thailand Personal Identification Number).

The Thailand Personal Identification Number is a unique personal identifier
assigned at birth or upon receiving Thai citizenship issue by the Ministry of
Interior.

This number consists of 13 digits which the last is a check digit. Usually
separated into five groups using hyphens to make it easier to read.

More information:

* https://en.wikipedia.org/wiki/Thai_identity_card
*)

exception Invalid_length
exception Invalid_format
exception Invalid_component
exception Invalid_checksum

val compact : string -> string
(** Convert the number to the minimal representation. This strips the number of
    any valid separators and removes surrounding whitespace. *)

val calc_check_digit : string -> string
(** Calculate the check digit for the first 12 digits. *)

val validate : string -> string
(** Check if the number is a valid PIN. This checks the length, formatting and
    check digit. Returns the normalized number if valid.
    @raise Invalid_checksum if the check digit is invalid *)

val validate_result : string -> (string, Tools.Error.t) result
(** Same as {!validate} but returns a [result] instead of raising exceptions. *)

val is_valid : string -> bool
(** Check whether the number is valid. Returns true if valid, false otherwise.
*)

val format : string -> string
(** Reformat the number to the standard presentation format (X-XXXX-XXXXX-XX-X).
*)
