(** ISAN (International Standard Audiovisual Number).

    The ISAN (International Standard Audiovisual Number) is used to identify
    audiovisual works.

    The number is hexadecimal and can consists of at least a root identifier,
    and an episode or part. After that an optional check digit, optional version
    and optionally another check digit can be provided. The check digits are
    validated using the ISO 7064 Mod 37, 36 algorithm.

    More information:
    - https://en.wikipedia.org/wiki/International_Standard_Audiovisual_Number *)

exception Invalid_format
(** Exception raised when the ISAN has invalid format. *)

exception Invalid_length
(** Exception raised when the ISAN has invalid length. *)

exception Invalid_checksum
(** Exception raised when the checksum validation fails. *)

val split : string -> string * string * string * string * string
(** Split the number into a root, an episode or part, a check digit, a version
    and another check digit. If any of the parts are missing an empty string is
    returned. *)

val compact : ?strip_check_digits:bool -> string -> string
(** Convert the ISAN to the minimal representation. This strips the number of
    any valid separators and removes surrounding whitespace. The check digits
    are removed by default. *)

val validate :
  ?strip_check_digits:bool -> ?add_check_digits:bool -> string -> string
(** Check if the number provided is a valid ISAN. If check digits are present in
    the number they are validated. If [strip_check_digits] is true any existing
    check digits will be removed (after checking). If [add_check_digits] is true
    the check digit will be added if they are not present yet. *)

val is_valid : string -> bool
(** Check if the number provided is a valid ISAN. If check digits are present in
    the number they are validated. Returns [true] if valid, [false] otherwise.
*)

val format :
     ?separator:string
  -> ?strip_check_digits:bool
  -> ?add_check_digits:bool
  -> string
  -> string
(** Reformat the number to the standard presentation format. If
    [add_check_digits] is true the check digit will be added if they are not
    present yet. If both [strip_check_digits] and [add_check_digits] are true
    the check digits will be recalculated. *)

val to_urn : string -> string
(** Return the URN representation of the ISAN. *)

val to_xml : string -> string
(** Return the XML form of the ISAN as a string. *)
