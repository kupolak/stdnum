(** TIN (Taxpayer Identification Number, Ghana tax number).

    This number is issued by the Ghana Revenue Authority (GRA) to individuals who
    are not eligible for the Ghanacard PIN and other entities.

    This number consists of 11 alphanumeric characters. It begins with one of the
    following prefixes:
    P00 For Individuals.
    C00 For Companies limited by guarantee, shares, Unlimited (i.e organisation required to register with the RGD).
    G00 Government Agencies, MDAs.
    Q00 Foreign Missions, Employees of foreign missions.
    V00 Public Institutions, Trusts, Co-operatives, Foreign Shareholder (Offshore), (Entities not registered by RGD).

    More information:
    - https://www.oecd.org/tax/automatic-exchange/crs-implementation-and-assistance/tax-identification-numbers/Ghana-TIN.pdf
    - https://gra.gov.gh/tin/
    - https://gra.gov.gh/tin/tin-faq/ *)

exception Invalid_format
(** Exception raised when the number has invalid format. *)

exception Invalid_length
(** Exception raised when the number has invalid length. *)

exception Invalid_checksum
(** Exception raised when the checksum validation fails. *)

val compact : string -> string
(** Convert the number to the minimal representation.
    This strips the number of any valid separators and removes surrounding
    whitespace. *)

val validate : string -> string
(** Check if the number is a valid Ghana TIN.

    @raise Invalid_format if the number contains invalid characters
    @raise Invalid_length if the length is not 11
    @raise Invalid_checksum if the checksum fails *)

val is_valid : string -> bool
(** Check if the number is a valid Ghana TIN. *)
