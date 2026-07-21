(** AMKA (Αριθμός Μητρώου Κοινωνικής Ασφάλισης, Greek social security number).

    The Αριθμός Μητρώου Κοινωνικής Ασφάλισης (AMKA or Arithmos Mitroou
    Koinonikis Asfalisis) is the personal identifier that is used for social
    security purposes in Greece. The number consists of 11 digits and includes
    the person's date of birth and gender.

    More information:
    - https://www.amka.gr/tieinai_en.html *)

exception Invalid_format
(** Exception raised when the number has invalid format. *)

exception Invalid_length
(** Exception raised when the number has invalid length. *)

exception Invalid_checksum
(** Exception raised when the checksum validation fails. *)

exception Invalid_component
(** Exception raised when the date of birth component is invalid. *)

val compact : string -> string
(** Convert the number to the minimal representation. This strips the number of
    any valid separators and removes surrounding whitespace. *)

val get_birth_date : string -> int * int * int
(** Split the date parts from the number and return the date of birth as (year,
    month, day). Since only two digits are used for the year, the century may be
    incorrect. *)

val get_gender : string -> string
(** Get the gender (M/F) from the person's AMKA. *)

val validate : string -> string
(** Check if the number is a valid AMKA. This checks the length, formatting and
    check digit.

    @raise Invalid_format if the number contains invalid characters
    @raise Invalid_length if the length is not 11
    @raise Invalid_checksum if the checksum fails
    @raise Invalid_component if the date of birth is invalid *)

val is_valid : string -> bool
(** Check if the number is a valid AMKA. *)
