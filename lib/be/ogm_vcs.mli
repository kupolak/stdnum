(** Belgian OGM-VCS.

    The OGM-VCS is used in bank transfer as structured communication.

    More information:
    - https://febelfin.be/en/publications/2023/febelfin-banking-standards-for-online-banking
*)

exception Invalid_format
exception Invalid_length
exception Invalid_checksum

val compact : string -> string
(** Convert the number to the minimal representation. This strips the number of
    any invalid separators and removes surrounding whitespace. *)

val calc_check_digits : string -> string
(** Calculate the check digit that should be added. *)

val validate : string -> string
(** Check if the number is a valid OGM-VCS.

    @raise Invalid_checksum if the checksum fails *)

val validate_result : string -> (string, Tools.Error.t) result
(** Same as {!validate} but returns a [result] instead of raising exceptions. *)

val is_valid : string -> bool
(** Check if the number is a valid OGM-VCS. *)

val format : string -> string
(** Format the number provided for output. *)
