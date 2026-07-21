(** NUIT (Número Único de Identificação Tributaria, Mozambique tax number).

    This number consists of 9 digits, sometimes separated in three groups of
    three digits using whitespace to make it easier to read.

    The first digit indicates the type of entity. The next seven digits are a
    sequential number. The last digit is the check digit, which is used to
    verify the number was correctly typed.

    More information:
    - https://www.mobilize.org.mz/nuit-numero-unico-de-identificacao-tributaria/
    - https://www.at.gov.mz/por/Perguntas-Frequentes2/NUIT *)

exception Invalid_format
exception Invalid_length
exception Invalid_checksum

val compact : string -> string
(** Convert the number to the minimal representation. *)

val calc_check_digit : string -> string
(** Calculate the check digit. *)

val validate : string -> string
(** Check if the number is a valid Mozambique NUIT number.

    @raise Invalid_checksum if the checksum fails *)

val validate_result : string -> (string, Tools.Error.t) result
(** Same as {!validate} but returns a [result] instead of raising exceptions. *)

val is_valid : string -> bool
(** Check if the number is a valid Mozambique NUIT number. *)

val format : string -> string
(** Reformat the number to the standard presentation format. *)
