(** AIC (Italian code for identification of drugs).

    AIC codes are used to identify drugs allowed to be sold in Italy. Codes are
    issued by the Italian Drugs Agency (AIFA, Agenzia Italiana del Farmaco), the
    government authority responsible for drugs regulation in Italy.

    The number consists of 9 digits and includes a check digit.

    More information:
    - https://www.gazzettaufficiale.it/do/atto/serie_generale/caricaPdf?cdimg=14A0566800100010110001&dgu=2014-07-18&art.dataPubblicazioneGazzetta=2014-07-18&art.codiceRedazionale=14A05668&art.num=1&art.tiposerie=SG *)

exception Invalid_format
exception Invalid_length
exception Invalid_checksum
exception Invalid_component

val compact : string -> string
(** Remove any formatting characters from the number and return a clean string. *)

val from_base32 : string -> string
(** Convert a BASE32 representation of an AIC to a BASE10 one.
    @raise Invalid_format if the number contains invalid BASE32 characters *)

val to_base32 : string -> string
(** Convert a BASE10 representation of an AIC to a BASE32 one.
    @raise Invalid_format if the number contains non-digit characters *)

val calc_check_digit : string -> string
(** Calculate the check digit for the BASE10 AIC code (first 8 digits). *)

val validate_base10 : string -> string
(** Check if a string is a valid BASE10 representation of an AIC.
    @raise Invalid_length if the number is not 9 digits
    @raise Invalid_format if the number contains non-digit characters
    @raise Invalid_component if the first digit is not '0'
    @raise Invalid_checksum if the check digit is invalid *)

val validate_base32 : string -> string
(** Check if a string is a valid BASE32 representation of an AIC.
    @raise Invalid_length if the number is not 6 characters
    @raise Invalid_format if the number contains invalid BASE32 characters
    @raise Invalid_checksum if the check digit is invalid *)

val validate : string -> string
(** Check if a string is a valid AIC. BASE10 is the canonical form (9 digits),
    while BASE32 is 6 characters. Returns the BASE10 representation.
    @raise Invalid_length if the number length is invalid
    @raise Invalid_format if the number format is invalid
    @raise Invalid_component if the first digit is not '0'
    @raise Invalid_checksum if the check digit is invalid *)

val is_valid : string -> bool
(** Check if the given string is a valid AIC code. *)
