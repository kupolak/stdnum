(** UID (Unternehmens-Identifikationsnummer, Swiss business identifier).

    The Swiss UID is used to uniquely identify businesses for taxation purposes.
    The number consists of a fixed "CHE" prefix, followed by 9 digits that are
    protected with a simple checksum.

    This module only supports the "new" format that was introduced in 2011 which
    completely replaced the "old" 6-digit format in 2014.
    Stripped numbers without the CHE prefix are allowed and validated,
    but are returned with the prefix prepended.

    More information:
    - https://www.uid.admin.ch/
    - https://de.wikipedia.org/wiki/Unternehmens-Identifikationsnummer *)

exception Invalid_format
exception Invalid_length
exception Invalid_checksum
exception Invalid_component

val compact : string -> string
(** Convert the number to the minimal representation. This strips
    surrounding whitespace and separators. Numbers without CHE prefix
    are automatically prepended with it. *)

val calc_check_digit : string -> string
(** Calculate the check digit for organisations. The number passed should
    not have the check digit included. *)

val validate : string -> string
(** Check if the number is a valid UID. This checks the length, formatting
    and check digit.
    @raise Invalid_format if the number contains invalid characters
    @raise Invalid_length if the number is not 12 characters
    @raise Invalid_component if the number doesn't start with CHE
    @raise Invalid_checksum if the checksum is invalid *)

val is_valid : string -> bool
(** Check if the number is a valid UID. *)

val format : string -> string
(** Reformat the number to the standard presentation format (CHE-XXX.XXX.XXX). *)
