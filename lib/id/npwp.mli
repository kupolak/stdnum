(** NPWP (Nomor Pokok Wajib Pajak, Indonesian VAT Number).

    The Nomor Pokok Wajib Pajak (NPWP) is assigned to organisations and
    individuals (families) by the Indonesian Tax Office after registration by
    the tax payers.

    The number consists of 16 digits and is either a NIK (Nomor Induk
    Kependudukan) or a number that starts with a 0, followed by 2 digits that
    denote the type of entity, 6 digits to identify the tax payer, a check digit
    over the first 8 digits followed by 3 digits to identify the local tax
    office and 3 digits for branch code.

    This module also accepts the old 15 digit format which is just the 16 digit
    format without the starting 0.

    More information:
    - https://www.oecd.org/tax/automatic-exchange/crs-implementation-and-assistance/tax-identification-numbers/Indonesia-TIN.pdf
    - https://metacpan.org/pod/Business::ID::NPWP
    - https://wiki.scn.sap.com/wiki/display/CRM/Indonesia *)

exception Invalid_format
exception Invalid_length
exception Invalid_checksum
exception Invalid_component

val compact : string -> string
(** Convert the number to the minimal representation. *)

val validate : string -> string
(** Check if the number is a valid Indonesia NPWP number.

    @raise Invalid_component if the date or place is invalid *)

val validate_result : string -> (string, Tools.Error.t) result
(** Same as {!validate} but returns a [result] instead of raising exceptions. *)

val is_valid : string -> bool
(** Check if the number is a valid Indonesia NPWP number. *)

val format : string -> string
(** Reformat the number to the standard presentation format. *)
