(** Leitweg-ID, a buyer reference or routing identifier for electronic invoices.

    For the successful transmission of an electronic invoice as invoicing party
    or sender, a unique identification and addressing of the invoice recipient
    is required. The Leitweg-ID must be transmitted as a mandatory requirement
    for electronic invoicing to public contracting authorities in the federal
    administration.

    More information:
    - https://leitweg-id.de/
    - https://de.wikipedia.org/wiki/Leitweg-ID
    - https://xeinkauf.de/app/uploads/2022/11/Leitweg-ID-Formatspezifikation-v2-0-2-1.pdf
*)

exception Invalid_format
exception Invalid_length
exception Invalid_component
exception Invalid_checksum

(** Exception raised when the Leitweg-ID has an invalid state or federal
    government code. *)

val compact : string -> string
(** Convert the number to the minimal representation. This strips the number of
    any valid separators and removes surrounding whitespace. *)

val validate : string -> string
(** Check if the number provided is valid. This checks the format, state or
    federal government code, and check digits.

    if the number contains invalid characters or bad format
    @raise Invalid_checksum if the checksum fails *)

val validate_result : string -> (string, Tools.Error.t) result
(** Same as {!validate} but returns a [result] instead of raising exceptions. *)

val is_valid : string -> bool
(** Check if the number provided is valid. This checks the length and check
    digit. *)
