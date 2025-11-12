(** Belgian VAT number (BTW, TVA, NWSt, ondernemingsnummer).

    The enterprise number (ondernemingsnummer) is a unique identifier of
    companies within the Belgian administrative services. It was previously
    the VAT ID number. The number consists of 10 digits. *)

exception Invalid_length
exception Invalid_format
exception Invalid_checksum
exception Invalid_component

val compact : string -> string
(** Convert the number to the minimal representation. This strips the
    number of any valid separators and removes surrounding whitespace. *)

val validate : string -> string
(** Check if the number is a valid VAT number. This checks the length,
    formatting and check digit. Returns the compacted number if valid,
    raises an exception otherwise. *)

val is_valid : string -> bool
(** Check if the number is a valid VAT number. Returns true if valid,
    false otherwise. *)
