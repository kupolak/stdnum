(** CPR (personnummer, the Danish citizen number).

    The CPR is the national number to identify Danish citizens and is stored in
    the Det Centrale Personregister (Civil Registration System). The number
    consists of 10 digits in the format DDMMYY-SSSS where the first part
    represents the birth date and the second a sequence number. The first digit
    of the sequence number indicates the century.

    More information:
    - https://en.wikipedia.org/wiki/Personal_identification_number_(Denmark)
    - https://da.wikipedia.org/wiki/CPR-nummer
    - https://cpr.dk/ *)

exception Invalid_format
(** Exception raised when the CPR has invalid format. *)

exception Invalid_length
(** Exception raised when the CPR has invalid length. *)

exception Invalid_component
(** Exception raised when the CPR has an invalid birth date component or the
    date is in the future. *)

val compact : string -> string
(** Convert the number to the minimal representation. This strips the number of
    any valid separators and removes surrounding whitespace. *)

val checksum : string -> int
(** Calculate the checksum. Note that the checksum isn't actually used any more.
    Valid numbers used to have a checksum of 0. *)

val get_birth_date : string -> int * int * int
(** Split the date parts from the number and return the birth date (year, month,
    day). *)

val validate : string -> string
(** Check if the number provided is a valid CPR number. This checks the length,
    formatting, and embedded date.

    @raise Invalid_format if the number contains invalid characters
    @raise Invalid_length if the length is not 10
    @raise Invalid_component if the date component is invalid or in the future
*)

val is_valid : string -> bool
(** Check if the number provided is a valid CPR number. *)

val format : string -> string
(** Reformat the number to the standard presentation format. *)
