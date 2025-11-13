(** Japanese Individual Number (個人番号, kojin bangō, My Number).

    The Japanese Individual Number (個人番号, kojin bangō), often referred to as My
    number (マイナンバー, mai nambā), is assigned to identify citizens and residents.
    The number consists of 12 digits where the last digit is a check digit. No
    personal information (such as name, gender, date of birth, etc.) is encoded
    in the number. *)

exception Invalid_length
exception Invalid_format
exception Invalid_checksum

val compact : string -> string
(** Convert the number to the minimal representation. This strips the
    number of any valid separators and removes surrounding whitespace. *)

val format : string -> string
(** Reformat the number to the presentation format found on My Number Cards. *)

val validate : string -> string
(** Check if the number is valid. This checks the length and check digit.
    Returns the compacted number if valid, raises an exception otherwise. *)

val is_valid : string -> bool
(** Check if the number is a valid IN. Returns true if valid,
    false otherwise. *)
