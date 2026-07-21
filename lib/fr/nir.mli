(** NIR (Numéro d'Inscription au Répertoire).

    The NIR is the French personal identification number, popularly known as the
    "social security number" or INSEE number. It consists of 15 digits:
    - 1 digit for gender (1=male, 2=female)
    - 2 digits for year of birth
    - 2 digits for month of birth
    - 2 digits for department of birth (can be 2A or 2B for Corsica)
    - 3 digits for municipality code
    - 3 digits for serial number
    - 2 check digits *)

exception Invalid_checksum
exception Invalid_length
exception Invalid_format

val compact : string -> string
(** Convert the number to the minimal representation. *)

val calc_check_digits : string -> string
(** Calculate the check digits for the number (first 13 digits). *)

val validate : string -> string
(** Check if the number is a valid NIR. Returns the normalized number if valid.

    @raise Invalid_length if the number has an invalid length *)

val validate_result : string -> (string, Tools.Error.t) result
(** Same as {!validate} but returns a [result] instead of raising exceptions. *)

val is_valid : string -> bool
(** Check if the number is a valid NIR. Returns [true] if valid, [false]
    otherwise. *)

val format : ?separator:string -> string -> string
(** Reformat the number to the standard presentation format. Default separator
    is a space.

    Example: [format "295109912611193"] returns ["2 95 10 99 126 111 93"] *)
