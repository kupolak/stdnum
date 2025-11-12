(** Belgian eID Number (electronic Identity Card Number).

    The eID is an electronic identity card (with chip), issued to Belgian citizens
    over 12 years old. The card number applies only to the card in question and
    should not be confused with the Belgian National Number (Rijksregisternummer,
    Numéro National), that is also included on the card.

    The card number consists of 12 digits in the form xxx-xxxxxxx-yy where
    yy is a check digit calculated as the remainder of dividing xxxxxxxxxx by 97.
    If the remainder is 0, the check number is set to 97. *)

exception Invalid_length
exception Invalid_format
exception Invalid_checksum

val compact : string -> string
(** Convert the number to the minimal representation. This strips the
    number of any valid separators and removes surrounding whitespace. *)

val format : string -> string
(** Reformat the number to the standard presentation format. *)

val validate : string -> string
(** Check if the number is a valid ID card number. This checks the length,
    formatting and check digit. Returns the compacted number if valid,
    raises an exception otherwise. *)

val is_valid : string -> bool
(** Check if the number is a valid Belgian ID Card number. Returns true if valid,
    false otherwise. *)
