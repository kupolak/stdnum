(** BRN (사업자 등록 번호, South Korea Business Registration Number).

    The Business Registration Number is issued by the district tax office in the
    local jurisdiction for tax purposes. The number consists of 10 digits and
    contain the tax office number (3 digits), the type of business (2 digits), a
    serially assigned value (4 digits) and a single check digit.

    More information:
    - https://www.oecd.org/tax/automatic-exchange/crs-implementation-and-assistance/tax-identification-numbers/Korea-TIN.pdf
*)

exception Invalid_format
(** Exception raised when the number has invalid format. *)

exception Invalid_length
(** Exception raised when the number has invalid length. *)

exception Invalid_component
(** Exception raised when a component of the number is invalid. *)

val compact : string -> string
(** Convert the number to the minimal representation.

    This strips the number of any valid separators and removes surrounding
    whitespace. *)

val validate : string -> string
(** Check if the number is a valid South Korea BRN number.

    This checks the length and formatting.

    @raise Invalid_format if the number contains invalid characters
    @raise Invalid_length if the length is not 10
    @raise Invalid_component
      if the tax office number, type of business, or serial value is invalid *)

val is_valid : string -> bool
(** Check if the number is a valid South Korea BRN number. *)

val format : string -> string
(** Reformat the number to the standard presentation format. *)
