(** RUC number (Registro Único de Contribuyentes, Paraguay tax number).

    The Registro Único del Contribuyente (RUC) is the unique taxpayer registry
    that maintains identification numbers for all persons (national or foreign)
    and legal entities in Paraguay.

    The RUC number for legal entities consists of 8 digits starting after
    80000000. Number for residents and foreigners are up to 9 digits. The last
    digit is a check digit.

    More information:
    - https://www.ruc.com.py/ *)

exception Invalid_format
(** Exception raised when the number has invalid format. *)

exception Invalid_length
(** Exception raised when the number has invalid length. *)

exception Invalid_checksum
(** Exception raised when the checksum validation fails. *)

val compact : string -> string
(** Convert the number to the minimal representation. This strips the
    number of any valid separators and removes surrounding whitespace. *)

val calc_check_digit : string -> string
(** Calculate the check digit. The number passed should not have the
    check digit included. *)

val validate : string -> string
(** Check if the number is a valid Paraguay RUC number. This checks the length,
    formatting and check digit. *)

val is_valid : string -> bool
(** Check if the number is a valid Paraguay RUC number. *)

val format : string -> string
(** Reformat the number to the standard presentation format. *)
