(** ISBN (International Standard Book Number).

    The ISBN is the International Standard Book Number, used to identify
    publications. An ISBN is used to identify books. Numbers can either have 10
    digits (in ISBN-10 format) or 13 digits (in ISBN-13, EAN compatible format).

    More information:
    - https://en.wikipedia.org/wiki/International_Standard_Book_Number
    - https://www.isbn-international.org/range_file_generation *)

exception Invalid_format
(** Exception raised when the number has invalid format. *)

exception Invalid_length
(** Exception raised when the number has invalid length. *)

exception Invalid_checksum
(** Exception raised when the checksum validation fails. *)

exception Invalid_component
(** Exception raised when a component of the number is invalid. *)

val compact : ?convert:bool -> string -> string
(** Convert the ISBN to the minimal representation. This strips the number of
    any valid ISBN separators and removes surrounding whitespace. If the
    [convert] parameter is [true] the number is also converted to ISBN-13
    format. *)

val validate : ?convert:bool -> string -> string
(** Check if the number provided is a valid ISBN (either a legacy 10-digit one
    or a 13-digit one). This checks the length and the check digit. If the
    [convert] parameter is [true] the number is converted to ISBN-13 format
    first.

    @raise Invalid_format if the number contains invalid characters
    @raise Invalid_length if the length is not 10 or 13
    @raise Invalid_checksum if the checksum fails
    @raise Invalid_component if the prefix is invalid *)

val is_valid : string -> bool
(** Check if the number provided is a valid ISBN. *)

val isbn_type : string -> string option
(** Check the passed number and return [Some "ISBN13"], [Some "ISBN10"] or
    [None] (for invalid) for checking the type of number passed. *)

val to_isbn13 : string -> string
(** Convert the number to ISBN-13 format. *)

val to_isbn10 : string -> string
(** Convert the number to ISBN-10 format. *)
