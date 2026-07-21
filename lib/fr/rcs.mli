(** RCS (French trade registration number for commercial companies).

    The RCS number (Registre du commerce et des sociétés) is given by INSEE to a
    company with commercial activity when created. It is required for most of
    administrative procedures.

    The number consists of "RCS" letters followed by name of the city where the company was registered
    followed by letter A for a retailer or B for society
    followed by the SIREN number

    More information:
    - https://entreprendre.service-public.fr/vosdroits/F31190
    - https://fr.wikipedia.org/wiki/Registre_du_commerce_et_des_soci%C3%A9t%C3%A9s_(France) *)

exception Invalid_format
(** Exception raised when the number has invalid format. *)

exception Invalid_length
(** Exception raised when the number has invalid length. *)

exception Invalid_checksum
(** Exception raised when the checksum validation fails. *)

val compact : string -> string
(** Convert the number to the minimal representation. *)

val validate : string -> string
(** Validate number is a valid French RCS number.

    @raise Invalid_format if the number contains invalid characters
    @raise Invalid_length if the length is incorrect
    @raise Invalid_checksum if the checksum fails *)

val is_valid : string -> bool
(** Check if the number provided is valid. *)

val format : string -> string
(** Reformat the number to the standard presentation format. *)

val to_siren : string -> string
(** Extract SIREN number from the RCS number.
    The SIREN number is the 9 last digits of the RCS number.

    @raise Invalid_format if the number cannot be parsed *)
