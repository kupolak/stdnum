(** ACN (Australian Company Number).

    The Australian Company Number (ACN) is a company identifier issued by the
    Australian Securities and Investments Commission.

    More information:
    - https://en.wikipedia.org/wiki/Australian_Company_Number *)

exception Invalid_format
(** Exception raised when the ACN has invalid format. *)

exception Invalid_length
(** Exception raised when the ACN has invalid length. *)

exception Invalid_checksum
(** Exception raised when the checksum validation fails. *)

val compact : string -> string
(** Convert the number to the minimal representation. This strips the number of
    any valid separators and removes surrounding whitespace. *)

val calc_check_digit : string -> string
(** Calculate the checksum. *)

val validate : string -> string
(** Check if the number is a valid ACN. This checks the length, formatting and
    check digit.

    @raise Invalid_format if the number contains invalid characters
    @raise Invalid_length if the length is not 9
    @raise Invalid_checksum if the checksum fails *)

val is_valid : string -> bool
(** Check if the number is a valid ACN. *)

val format : string -> string
(** Reformat the number to the standard presentation format. *)

val to_abn : string -> string
(** Convert the number to an Australian Business Number (ABN). *)
