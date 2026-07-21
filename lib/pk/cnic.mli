(** CNIC number (Pakistani Computerised National Identity Card number).

    The CNIC (Computerised National Identity Card, قومی شناختی کارڈ) or SNIC
    (Smart National Identity Card) is issued by by Pakistan's NADRA (National
    Database and Registration Authority) to citizens of 18 years or older.

    The number consists of 13 digits and encodes the person's locality (5
    digits), followed by 7 digit serial number an a single digit indicating
    gender.

    More Information:
    - https://en.wikipedia.org/wiki/CNIC_(Pakistan)
    - https://www.nadra.gov.pk/identity/identity-cnic/ *)

exception Invalid_format
(** Exception raised when the number has invalid format. *)

exception Invalid_length
(** Exception raised when the number has invalid length. *)

exception Invalid_component
(** Exception raised when a component of the number is invalid. *)

val compact : string -> string
(** Convert the number to the minimal representation. This strips the number of
    any valid separators and removes surrounding whitespace. *)

val get_gender : string -> string option
(** Get the person's birth gender (["M"] or ["F"]). *)

val get_province : string -> string option
(** Get the person's province. *)

val validate : string -> string
(** Check if the number is a valid CNIC. This checks the length, formatting and
    some digits. *)

val is_valid : string -> bool
(** Check if the number is a valid CNIC. *)

val format : string -> string
(** Reformat the number to the standard presentation format. *)
