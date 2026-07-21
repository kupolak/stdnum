(** NIFp (Numéro d'Identification Fiscale Permanent, Guinea tax number).

    This number consists of 9 digits, usually separated into three groups using
    hyphens to make it easier to read. The first eight digits are assigned in a
    pseudorandom manner. The last digit is the check digit.

    More information:
    - https://dgi.gov.gn/wp-content/uploads/2022/09/N%C2%B0-12-Cahier-de-Charges-NIF-p.pdf
*)

exception Invalid_format
exception Invalid_length
exception Invalid_checksum

val compact : string -> string
(** Convert the number to the minimal representation. This strips the number of
    any valid separators and removes surrounding whitespace. *)

val validate : string -> string
(** Check if the number is a valid Guinea NIFp number. This checks the length,
    formatting and check digit.

    @raise Invalid_checksum if the checksum fails *)

val validate_result : string -> (string, Tools.Error.t) result
(** Same as {!validate} but returns a [result] instead of raising exceptions. *)

val is_valid : string -> bool
(** Check if the number is a valid Guinea NIFp number. *)

val format : string -> string
(** Reformat the number to the standard presentation format. *)
