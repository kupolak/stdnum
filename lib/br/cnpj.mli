(** CNPJ (Cadastro Nacional da Pessoa Jurídica, Brazilian company identifier).

    Numbers from the national register of legal entities have 14 alphanumeric
    digits. The first 8 digits identify the company, the following 4 digits
    identify a business unit and the last 2 digits are check digits.

    More information:
    - https://en.wikipedia.org/wiki/CNPJ *)

exception Invalid_format
exception Invalid_length
exception Invalid_checksum

val compact : string -> string
(** Convert the number to the minimal representation. This strips the number of
    any valid separators and removes surrounding whitespace. *)

val calc_check_digits : string -> string
(** Calculate the check digits for the number. *)

val validate : string -> string
(** Check if the number is a valid CNPJ. This checks the length and whether the
    check digits are correct.

    @raise Invalid_checksum if the checksum fails *)

val validate_result : string -> (string, Tools.Error.t) result
(** Same as {!validate} but returns a [result] instead of raising exceptions. *)

val is_valid : string -> bool
(** Check if the number is a valid CNPJ. *)

val format : string -> string
(** Reformat the number to the standard presentation format. *)
