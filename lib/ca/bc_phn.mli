(** BC PHN (British Columbia Personal Health Number).

    A unique, numerical, lifetime identifier used in the specific identification
    of an individual client or patient who has had any interaction with the
    British Columbia health system. It is assigned only to and used by one
    person and will not be assigned to any other person.

    The existence of a PHN does not imply eligibility for health care services
    in BC or provide any indication of an individual’s benefit status.

    The PNH is a 10-digit number where the first digit is always 9, and the last
    digit is a MOD-11 check digit.

    More information:
    - https://www2.gov.bc.ca/gov/content/health/health-drug-coverage/msp/bc-residents/personal-health-identification
    - https://www2.gov.bc.ca/assets/gov/health/practitioner-pro/software-development-guidelines/conformance-standards/vol-4b-app-rules-client-registry.pdf
*)

exception Invalid_format
exception Invalid_length
exception Invalid_component
exception Invalid_checksum

val compact : string -> string
(** Convert the number to the minimal representation. This strips the number of
    any valid separators and removes surrounding whitespace. *)

val calc_check_digit : string -> string
(** Calculate the check digit. The number passed should not have the check digit
    included. *)

val validate : string -> string
(** Check if the number is a valid PHN. This checks the length, formatting and
    check digit.

    @raise Invalid_checksum if the checksum fails *)

val validate_result : string -> (string, Tools.Error.t) result
(** Same as {!validate} but returns a [result] instead of raising exceptions. *)

val is_valid : string -> bool
(** Check if the number is a valid PHN. *)

val format : string -> string
(** Reformat the number to the standard presentation format. *)
