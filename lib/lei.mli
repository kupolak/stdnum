(** LEI (Legal Entity Identifier).

    The Legal Entity Identifier (LEI) is used to identify legal entities for use
    in financial transactions. A LEI is a 20-character alphanumeric string that
    consists of a 4-character issuing LOU (Local Operating Unit), 2 digits that
    are often 0, 13 digits to identify the organisation and 2 check digits.

    More information:
    - https://en.wikipedia.org/wiki/Legal_Entity_Identifier *)

exception Invalid_format
exception Invalid_checksum

val compact : string -> string
(** Convert the number to the minimal representation. This strips the number of
    any valid separators and removes surrounding white space.

    Example: [compact "213800KUD8LAJWSQ9D15"] returns ["213800KUD8LAJWSQ9D15"]
*)

val validate : string -> string
(** Check if the number is valid. This checks the length, format and check
    digits. Returns the normalized number if valid.

    if the number contains invalid characters or has wrong length
    @raise Invalid_checksum if the checksum validation fails *)

val validate_result : string -> (string, Tools.Error.t) result
(** Same as {!validate} but returns a [result] instead of raising exceptions. *)

val is_valid : string -> bool
(** Check if the number is valid. Returns [true] if valid, [false] otherwise. *)
