(** VAT, MWST, TVA, IVA, TPV (Mehrwertsteuernummer, the Swiss VAT number).

    The Swiss VAT number is based on the UID but is followed by either "MWST"
    (Mehrwertsteuer, the German abbreviation for VAT), "TVA" (Taxe sur la valeur
    ajoutée in French), "IVA" (Imposta sul valore aggiunto in Italian) or "TPV"
    (Taglia sin la plivalur in Romanian).

    This module only supports the "new" format that was introduced in 2011 which
    completely replaced the "old" 6-digit format in 2014.

    More information:
    - https://www.ch.ch/en/value-added-tax-number-und-business-identification-number/
    - https://www.uid.admin.ch/ *)

exception Invalid_format
exception Invalid_length
exception Invalid_checksum
exception Invalid_component

val compact : string -> string
(** Convert the number to the minimal representation. This strips
    surrounding whitespace and separators. *)

val validate : string -> string
(** Check if the number is a valid VAT number. This checks the length,
    formatting and check digit.
    @raise Invalid_format if the number contains invalid characters
    @raise Invalid_length if the number is not 15 or 16 characters
    @raise Invalid_component if the suffix is not MWST, TVA, IVA, or TPV
    @raise Invalid_checksum if the UID checksum is invalid *)

val is_valid : string -> bool
(** Check if the number is a valid VAT number. *)

val format : string -> string
(** Reformat the number to the standard presentation format (CHE-XXX.XXX.XXX SUFFIX). *)
