(*
   NIP (Numer Identyfikacji Podatkowej, Polish VAT number).

   The NIP (Numer Identyfikacji Podatkowej) number consists of 10 digit with
   a straightforward weighted checksum. 
*)

exception Invalid_format
(** Exception raised for an invalid NIP format. *)

exception Invalid_length
(** Exception raised for an invalid NIP length. *)

exception Invalid_checksum
(** Exception raised for an invalid NIP checksum. *)

val compact : string -> string
(** [compact number] converts the NIP number to its minimal representation.
    @param number The NIP number.
    @return The compacted NIP number. *)

val checksum : string -> int
(** [checksum number] calculates the checksum for the NIP number.
    @param number The NIP number.
    @return The checksum value. *)

val validate : string -> string
(** [validate number] checks if the NIP number is valid.
    @param number The NIP number to validate.
    @return The compacted NIP number if valid.
    @raises Invalid_format if the format is invalid.
    @raises Invalid_length if the length is invalid.
    @raises Invalid_checksum if the checksum is invalid. *)

val is_valid : string -> bool
(** [is_valid number] checks if the NIP number is valid.
    @param number The NIP number to check.
    @return true if the NIP number is valid, false otherwise. *)

val format : string -> string
(** [format number] reformats the NIP number to the standard presentation format.
    @param number The NIP number.
    @return The formatted NIP number. *)
