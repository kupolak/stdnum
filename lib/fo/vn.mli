(** V-number (Vinnutal, Faroe Islands tax number).

    In the Faroe Islands the legal persons TIN equals the V number issued by the
    Faroese Tax Administration. It is a consecutive number.

    More information:
    - https://www.taks.fo/fo/borgari/bolkar/at-stovna-virki/
    - https://www.oecd.org/tax/automatic-exchange/crs-implementation-and-assistance/tax-identification-numbers/Faroe-islands-TIN.pdf
*)

exception Invalid_format
(** Exception raised when the number has invalid format. *)

exception Invalid_length
(** Exception raised when the number has invalid length. *)

val compact : string -> string
(** Convert the number to the minimal representation. This strips the number of
    any valid separators and removes surrounding whitespace. *)

val validate : string -> string
(** Check if the number is a valid Faroe Islands V-number number. This checks
    the length and formatting.

    @raise Invalid_format if the number contains invalid characters
    @raise Invalid_length if the length is not 6 *)

val is_valid : string -> bool
(** Check if the number is a valid Faroe Islands V-number number. *)

val format : string -> string
(** Reformat the number to the standard presentation format. *)
