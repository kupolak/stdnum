(** Singapore UEN (Unique Entity Number).

    The Unique Entity Number (UEN) is a 9 or 10 digit identification issued by
    the government of Singapore to businesses that operate within Singapore.

    There are three different formats:
    - Business (ROB): 8 digits followed by a check letter
    - Local Company (ROC): 9 digits (first 4 digits represent year of issuance)
      followed by a check letter
    - Others: 10 characters starting with R/S/T, followed by 2 digits (year),
      2 letters (entity type), 4 digits, and a check letter
*)

exception Invalid_length
(** Exception raised when the UEN has an invalid length (not 9 or 10 characters). *)

exception Invalid_format
(** Exception raised when the UEN contains invalid characters or format. *)

exception Invalid_component
(** Exception raised when the UEN has invalid components (e.g., invalid year,
    invalid entity type). *)

exception Invalid_checksum
(** Exception raised when the check digit is invalid. *)

val compact : string -> string
(** Convert the number to the minimal representation. This converts to uppercase
    and removes surrounding whitespace. *)

val calc_business_check_digit : string -> string
(** Calculate the check digit for Business (ROB) numbers using weights
    [10,4,9,3,8,2,7,1] and check characters "XMKECAWLJDB". *)

val validate_business : string -> string
(** Validate a 9-digit Business (ROB) UEN number.

    @raise Invalid_format if the first 8 characters are not digits or the last
           character is not alphabetic
    @raise Invalid_checksum if the check digit is invalid *)

val calc_local_company_check_digit : string -> string
(** Calculate the check digit for Local Company (ROC) numbers using weights
    [10,8,6,4,9,7,5,3,1] and check characters "ZKCMDNERGWH". *)

val validate_local_company : string -> string
(** Validate a 10-digit Local Company (ROC) UEN number.

    @raise Invalid_format if the first 9 characters are not digits
    @raise Invalid_component if the year (first 4 digits) is in the future
    @raise Invalid_checksum if the check digit is invalid *)

val calc_other_check_digit : string -> string
(** Calculate the check digit for other entity UEN numbers using an alphanumeric
    alphabet and weights [4,3,5,3,10,2,2,5,7]. *)

val validate_other : string -> string
(** Validate a 10-character other entity UEN number.

    @raise Invalid_component if the first character is not R/S/T, or if the
           entity type is invalid, or if year validation fails for T entities
    @raise Invalid_format if the format is invalid
    @raise Invalid_checksum if the check digit is invalid *)

val validate : string -> string
(** Check if the number is a valid Singapore UEN number. This checks the length
    and routes to the appropriate validation function based on the format.
    Returns the normalized number if valid.

    @raise Invalid_length if the number is not 9 or 10 characters
    @raise Invalid_format if the format is invalid
    @raise Invalid_component if components are invalid
    @raise Invalid_checksum if the check digit is invalid *)

val is_valid : string -> bool
(** Check if the number is a valid Singapore UEN number.
    Returns [true] if valid, [false] otherwise. *)

val format : string -> string
(** Reformat the number to the standard presentation format. *)
