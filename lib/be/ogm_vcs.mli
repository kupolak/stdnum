(** Belgian OGM-VCS.

    The OGM-VCS is used in bank transfer as structured communication.

    More information:
    - https://febelfin.be/en/publications/2023/febelfin-banking-standards-for-online-banking
*)

exception Invalid_format
(** Exception raised when the OGM-VCS has invalid format. *)

exception Invalid_length
(** Exception raised when the OGM-VCS has invalid length. *)

exception Invalid_checksum
(** Exception raised when the checksum validation fails. *)

val compact : string -> string
(** Convert the number to the minimal representation. This strips the number of
    any invalid separators and removes surrounding whitespace. *)

val calc_check_digits : string -> string
(** Calculate the check digit that should be added. *)

val validate : string -> string
(** Check if the number is a valid OGM-VCS.

    @raise Invalid_format if the number contains invalid characters
    @raise Invalid_length if the length is not 12
    @raise Invalid_checksum if the checksum fails *)

val is_valid : string -> bool
(** Check if the number is a valid OGM-VCS. *)

val format : string -> string
(** Format the number provided for output. *)
