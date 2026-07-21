(** GSTIN (Goods and Services Tax identification number, Indian VAT number).

    The Goods and Services Tax identification number (GSTIN) is a 15 digit
    unique identifier assigned to all business entities in India registered
    under the Goods and Services Tax (GST) Act, 2017.

    Each GSTIN begins with a 2 digit state code, the next 10 characters are the
    holder's PAN, the 13th character is an alphanumeric digit that represents
    the number of GSTIN registrations made in a state or union territory for
    same the PAN, the 14th character is 'Z' and the last character is an
    alphanumeric check digit calculated using Luhn mod 36 algorithm.

    More information:
    - https://bajajfinserv.in/insights/what-is-goods-and-service-tax-identification-number
    - https://ddvat.gov.in/docs/List%20of%20State%20Code.pdf
    - https://en.wikipedia.org/wiki/Goods_and_Services_Tax_(India) *)

exception Invalid_format
exception Invalid_length
exception Invalid_component
exception Invalid_checksum

val compact : string -> string
(** Convert the number to the minimal representation. This strips the number of
    any valid separators and removes surrounding whitespace. *)

val to_pan : string -> string
(** Convert the number to a PAN. *)

type gstin_info = {
    state : string option
  ; pan : string
  ; holder_type : string
  ; initial : string
  ; registration_count : int
}

val info : string -> gstin_info
(** Provide information that can be decoded locally from GSTIN (without API). *)

val validate : string -> string
(** Check if the number provided is a valid GSTIN. This checks the length,
    formatting and check digit.

    @raise Pan.Invalid_format if the embedded PAN has invalid format
    @raise Pan.Invalid_length if the embedded PAN has invalid length
    @raise Pan.Invalid_component if the embedded PAN has invalid component *)

val validate_result : string -> (string, Tools.Error.t) result
(** Same as {!validate} but returns a [result] instead of raising exceptions. *)

val is_valid : string -> bool
(** Check if the number provided is a valid GSTIN. This checks the length,
    formatting and check digit. *)
