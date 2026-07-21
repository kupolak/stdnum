(** Company Number (מספר חברה, or short ח.פ. Israeli company number).

    It consists of nine digits and includes a check digit. For companies the
    first digit is a 5. The first two digits identify the type of company.

    More information:
    - https://he.wikipedia.org/wiki/תאגיד#מספר_רישום_התאגיד
    - https://www.oecd.org/tax/automatic-exchange/crs-implementation-and-assistance/tax-identification-numbers/Israel-TIN.pdf
    - https://wiki.scn.sap.com/wiki/display/CRM/Israel *)

exception Invalid_format
(** Exception raised when the number has invalid format. *)

exception Invalid_length
(** Exception raised when the number has invalid length. *)

exception Invalid_checksum
(** Exception raised when the checksum validation fails. *)

exception Invalid_component
(** Exception raised when the number has an invalid component. *)

val compact : string -> string
(** Convert the number to the minimal representation. This strips the number of
    any valid separators and removes surrounding whitespace. *)

val validate : string -> string
(** Check if the number provided is a valid ID. This checks the length,
    formatting and check digit.

    @raise Invalid_format if the number contains invalid characters
    @raise Invalid_length if the length is not correct
    @raise Invalid_component if the first digit is not 5
    @raise Invalid_checksum if the checksum fails *)

val is_valid : string -> bool
(** Check if the number provided is a valid ID. This checks the length,
    formatting and check digit. *)

val format : string -> string
(** Reformat the number to the standard presentation format. *)
