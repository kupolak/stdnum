(** New Zealand bank account number

    The New Zealand bank account numbers consist of 16 digits. The first two
    represent the bank, followed by four for the branch, seven digits for the
    account base number and three for the account type.

    More information:
    - https://en.wikipedia.org/wiki/New_Zealand_bank_account_number *)

exception Invalid_format
(** Exception raised when the number has invalid format. *)

exception Invalid_length
(** Exception raised when the number has invalid length. *)

exception Invalid_checksum
(** Exception raised when the checksum validation fails. *)

exception Invalid_component
(** Exception raised when a component of the number is invalid. *)

val compact : string -> string
(** Convert the number to the minimal representation. This strips the
    number of any valid separators and removes surrounding whitespace. *)

val validate : string -> string
(** Check if the number provided is a valid bank account number.

    @raise Invalid_format if the number contains invalid characters
    @raise Invalid_length if the length is not 16
    @raise Invalid_checksum if the checksum fails
    @raise Invalid_component if the bank or branch is invalid *)

val is_valid : string -> bool
(** Check if the number provided is a valid bank account number. *)

val format : string -> string
(** Reformat the number to the standard presentation format. *)
