(** Tax Registration Number (الرقم الضريبي, Egypt tax number).

    This number consists of 9 digits, usually separated into three groups using
    hyphens to make it easier to read, like XXX-XXX-XXX.

    More information:
    - https://emsp.mts.gov.eg:8181/EMDB-web/faces/authoritiesandcompanies/authority/website/SearchAuthority.xhtml?lang=en
*)

exception Invalid_format
exception Invalid_length

val compact : string -> string
(** Convert the number to the minimal representation. This strips the number of
    any valid separators and removes surrounding whitespace. It also converts
    arabic numbers. *)

val validate : string -> string
(** Check if the number is a valid Egypt Tax Number. This checks the length and
    formatting.

    @raise Invalid_length if the length is not 9 *)

val validate_result : string -> (string, Tools.Error.t) result
(** Same as {!validate} but returns a [result] instead of raising exceptions. *)

val is_valid : string -> bool
(** Check if the number is a valid Egypt Tax Number. *)

val format : string -> string
(** Reformat the number to the standard presentation format. *)
