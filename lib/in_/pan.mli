(** PAN (Permanent Account Number, Indian income tax identifier).

    The Permanent Account Number (PAN) is a 10 digit alphanumeric identifier for
    Indian individuals, families and corporates for income tax purposes. It is
    also issued to foreign nationals subject to a valid visa.

    PAN is made up of 5 letters, 4 digits and 1 alphabetic check digit. The 4th
    character indicates the type of holder, the 5th character is either 1st
    letter of the holder's name or holder's surname in case of 'Individual' PAN,
    next 4 digits are serial numbers running from 0001 to 9999 and the last
    character is a check digit computed by an undocumented checksum algorithm.

    More information:
    - https://en.wikipedia.org/wiki/Permanent_account_number
    - https://incometaxindia.gov.in/tutorials/1.permanent%20account%20number%20(pan).pdf
*)

exception Invalid_format
(** Exception raised when the number has invalid format. *)

exception Invalid_length
(** Exception raised when the number has invalid length. *)

exception Invalid_component
(** Exception raised when the number has an invalid component. *)

val compact : string -> string
(** Convert the number to the minimal representation. This strips the number of
    any valid separators and removes surrounding whitespace. *)

val info : string -> string * string
(** Provide information that can be decoded from the PAN. Returns a tuple
    containing the holder type and the initial character. *)

val validate : string -> string
(** Check if the number provided is a valid PAN. This checks the length and
    formatting.

    @raise Invalid_format if the number contains invalid characters
    @raise Invalid_length if the length is not 10
    @raise Invalid_component
      if the holder type is invalid or serial number is 0000 *)

val is_valid : string -> bool
(** Check if the number provided is a valid PAN. This checks the length and
    formatting. *)

val mask : string -> string
(** Mask the PAN as per Central Board of Direct Taxes (CBDT) masking standard.
*)
