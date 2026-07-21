(** UPN (English Unique Pupil Number).

    The Unique Pupil Number (UPN) is a 13-character code that identifies pupils
    in English state schools and is designed to aid tracking pupil progress
    through the school system.

    The number consists of a check letter, a 3-digit LA (Local Authority) number
    for the issuing school, a 4-digit DfE number (School Establishment Number),
    2 digits for the issue year and 3 digits for a serial number. Temporary
    numbers have a 2-digit serial and a letter.

    More information:
    - https://www.gov.uk/government/publications/unique-pupil-numbers *)

exception Invalid_format
exception Invalid_length
exception Invalid_component
exception Invalid_checksum

(** Exception raised when the UPN has an invalid component (e.g. unknown LA
    number). *)

val compact : string -> string
(** Convert the number to the minimal representation. This strips the number of
    any valid separators and removes surrounding whitespace. *)

val calc_check_digit : string -> string
(** Calculate the check digit for the number. *)

val validate : string -> string
(** Check if the number is a valid UPN. This checks length, formatting and check
    digits.

    @raise Invalid_checksum if the checksum fails *)

val validate_result : string -> (string, Tools.Error.t) result
(** Same as {!validate} but returns a [result] instead of raising exceptions. *)

val is_valid : string -> bool
(** Check if the number is a valid UPN. *)
