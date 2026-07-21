(** TFN (Australian Tax File Number).

    The Tax File Number (TFN) is issued by the Australian Taxation Office (ATO)
    to taxpaying individuals and organisations. A business has both a TFN and an
    Australian Business Number (ABN).

    The number consists of 8 (older numbers) or 9 digits and includes a check
    digit but otherwise without structure.

    More information:
    - https://en.wikipedia.org/wiki/Tax_file_number
    - https://www.ato.gov.au/Individuals/Tax-file-number/ *)

exception Invalid_format
exception Invalid_length
exception Invalid_checksum

val compact : string -> string
(** Convert the number to the minimal representation. This strips the number of
    any valid separators and removes surrounding whitespace. *)

val checksum : string -> int
(** Calculate the checksum. *)

val validate : string -> string
(** Check if the number is a valid TFN. This checks the length, formatting and
    check digit.

    @raise Invalid_checksum if the checksum fails *)

val validate_result : string -> (string, Tools.Error.t) result
(** Same as {!validate} but returns a [result] instead of raising exceptions. *)

val is_valid : string -> bool
(** Check if the number is a valid TFN. *)

val format : string -> string
(** Reformat the number to the standard presentation format. *)
