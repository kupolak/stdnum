(** HETU (Henkilötunnus, Finnish personal identity code).

    Module for handling Finnish personal identity codes (HETU, Henkilötunnus).
    See https://www.vaestorekisterikeskus.fi/default.aspx?id=45 for checksum
    calculation details and
    https://tarkistusmerkit.teppovuori.fi/tarkmerk.htm#hetu1 for historical
    details. *)

exception Invalid_format
exception Invalid_length
exception Invalid_component
exception Invalid_checksum

val compact : string -> string
(** Convert the HETU to the minimal representation. This strips surrounding
    whitespace and converts it to upper case. *)

val format : string -> string
(** Format the HETU. (Returns the compact string) *)

val validate : ?allow_temporary:bool -> string -> string
(** Check if the number is a valid HETU. It checks the format, whether a valid
    date is given and whether the check digit is correct. Allows temporary
    identifier range for individuals (900-999) if allow_temporary is true.

    @raise Invalid_checksum if the checksum fails *)

val validate_result :
  ?allow_temporary:bool -> string -> (string, Tools.Error.t) result
(** Same as {!validate} but returns a [result] instead of raising exceptions. *)

val is_valid : ?allow_temporary:bool -> string -> bool
(** Check if the number is a valid HETU. *)
