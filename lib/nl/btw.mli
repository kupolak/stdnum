(** Btw-identificatienummer (Omzetbelastingnummer, the Dutch VAT number).

    The btw-identificatienummer (previously the btw-nummer) is the Dutch number
    for identifying parties in a transaction for which VAT is due. The btw-nummer
    is used in communication with the tax agency while the
    btw-identificatienummer (EORI-nummer) can be used when dealing with other
    companies though they are used interchangeably.

    The btw-nummer consists of a RSIN or BSN followed by the letter B and two
    digits that identify the number of the company created. The
    btw-identificatienummer has a similar format but different checksum and does
    not contain the BSN.

    More information:
    - https://en.wikipedia.org/wiki/VAT_identification_number
    - https://nl.wikipedia.org/wiki/Btw-nummer_(Nederland) *)

exception Invalid_format
exception Invalid_length
exception Invalid_checksum

val compact : string -> string
(** Remove any formatting characters from the number, strip NL prefix if present,
    and return a clean string. *)

val validate : string -> string
(** Check if the number is a valid btw number. This checks the length,
    formatting and check digit (either BSN or mod 97-10).
    @raise Invalid_format if the number format is invalid
    @raise Invalid_length if the number is not 12 characters
    @raise Invalid_checksum if neither BSN nor mod 97-10 checksum is valid *)

val is_valid : string -> bool
(** Check if the number is a valid btw number. *)
