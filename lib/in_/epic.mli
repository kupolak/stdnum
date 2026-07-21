(** EPIC (Electoral Photo Identity Card, Indian Voter ID).

    The Electoral Photo Identity Card (EPIC) is an identity document issued by
    the Election Commission of India (ECI) only to the India citizens who have
    reached the age of 18.

    Each EPIC contains an unique 10 digit alphanumeric identifier known as EPIC
    number or Voter ID number.

    Every EPIC number begins with a Functional Unique Serial Number (FUSN), a 3
    letter unique identifier for each Assembly Constituency. FUSN is followed by
    a 6 digit serial number and 1 check digit of the serial number calculated
    using Luhn algorithm.

    More information:
    - https://en.wikipedia.org/wiki/Voter_ID_(India)
    - https://www.kotaksecurities.com/ksweb/voter-id/serial-number-in-elctoral-roll
*)

exception Invalid_format
exception Invalid_length
exception Invalid_checksum

val compact : string -> string
(** Convert the number to the minimal representation. This strips the number of
    any valid separators and removes surrounding whitespace. *)

val validate : string -> string
(** Check if the number provided is a valid EPIC number. This checks the length,
    formatting and checksum.

    @raise Invalid_checksum if the checksum fails *)

val validate_result : string -> (string, Tools.Error.t) result
(** Same as {!validate} but returns a [result] instead of raising exceptions. *)

val is_valid : string -> bool
(** Check if the number provided is a valid EPIC number. This checks the length,
    formatting and checksum. *)
