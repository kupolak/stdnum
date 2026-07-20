(** IMEI (International Mobile Equipment Identity).

    The IMEI is used to identify mobile phones. An IMEI is 14, 15 (when the
    check digit is included) or 16 digits (IMEISV) long. The check digit is
    validated using the Luhn algorithm.

    More information:
    - https://en.wikipedia.org/wiki/International_Mobile_Equipment_Identity *)

exception Invalid_format
(** Exception raised when the IMEI has invalid format. *)

exception Invalid_length
(** Exception raised when the IMEI has invalid length. *)

exception Invalid_checksum
(** Exception raised when the checksum validation fails. *)

val compact : string -> string
(** Convert the IMEI number to the minimal representation. This strips the
    number of any valid separators and removes surrounding whitespace.

    Example: [compact "35-686800-004141-20"] returns ["3568680000414120"] *)

val validate : string -> string
(** Check if the number provided is a valid IMEI (or IMEISV) number.
    Returns the normalized number if valid.

    @raise Invalid_format if the number contains non-digit characters
    @raise Invalid_length if the number has invalid length (not 14, 15, or 16 digits)
    @raise Invalid_checksum if the Luhn checksum validation fails (15-digit only) *)

val imei_type : string -> string option
(** Check the passed number and return [Some "IMEI"], [Some "IMEISV"] or [None]
    (for invalid) for checking the type of number passed. *)

val is_valid : string -> bool
(** Check if the number provided is a valid IMEI (or IMEISV) number.
    Returns [true] if valid, [false] otherwise. *)

val split : string -> string * string * string
(** Split the number into a Type Allocation Code (TAC), serial number
    and either the checksum (for IMEI) or the software version number
    (for IMEISV).

    Example: [split "35686800-004141"] returns [("35686800", "004141", "")] *)

val format :
  ?separator:string -> ?add_check_digit:bool -> string -> string
(** Reformat the number to the standard presentation format.

    Example: [format "354178036859789"] returns ["35-417803-685978-9"]
    Example: [format ~add_check_digit:true "35686800-004141"] returns
    ["35-686800-004141-8"] *)
