(*
NIT (Número de Identificación Tributaria, El Salvador tax number).

This number consists of 14 digits, usually separated into four groups
using hyphens to make it easier to read, like XXXX-XXXXXX-XXX-X.

The first four digits indicate the code for the municipality of birth
for natural persons or the municipality of stablishment for juridical
persons. NIT for El Salvador nationals begins with either 0 or 1, and
for foreigners it begins with 9.

The following six digits indicate the date of birth for the natural
person, or the stablishment date for the juridical person, using the
format DDMMYY, where DD is the day, MM is the month, and YY is the
year. For example XXXX-051180-XXX-X is (November 5 1980)

The next 3 digits are a sequential number.

The last digit is the check digit, which is used to verify the number
was correctly typed.

More information:

* https://es.wikipedia.org/wiki/Identificaci%C3%B3n_tributaria
* https://www.listasal.info/articulos/nit-el-salvador.shtml
* https://tramitesyrequisitos.com/el-salvador/nit/#Estructura_del_NIT
*)

exception Invalid_length
(** Exception raised when the NIT has an invalid length. *)

exception Invalid_format
(** Exception raised when the NIT has an invalid format. *)

exception Invalid_component
(** Exception raised when the NIT does not start with 0, 1, or 9. *)

exception Invalid_checksum
(** Exception raised when the check digit is invalid. *)

val compact : string -> string
(** Convert the number to the minimal representation.
    This strips the number of any valid separators, removes "SV" prefix if present,
    and removes surrounding whitespace. *)

val calc_check_digit : string -> string
(** Calculate the check digit. Uses different algorithm for old NIT (sequential <= 100)
    versus new NIT (sequential > 100). *)

val validate : string -> string
(** Check if the number is a valid El Salvador NIT number.
    This checks the length, formatting and check digit. Returns the normalized number if valid.
    @raise Invalid_length if the number length is not 14
    @raise Invalid_format if the number contains non-digit characters
    @raise Invalid_component if the number does not start with 0, 1, or 9
    @raise Invalid_checksum if the check digit is invalid *)

val is_valid : string -> bool
(** Check if the number is a valid El Salvador NIT number.
    Returns true if valid, false otherwise. *)

val format : string -> string
(** Reformat the number to the standard presentation format (XXXX-XXXXXX-XXX-X). *)
