(* functions for performing the ISO 7064 Mod 37, 2 algorithm *)

exception Invalid_checksum
(** Exception raised for an invalid checksum. *)

exception Not_found
(** Exception raised when a character is not found in the alphabet. *)

(* Alphabet used for checksum calculation *)
val alphabet : string

(* Function to find the index of a character in a string *)
val index : string -> char -> int

(* Function to calculate the checksum of a number *)
val checksum : ?alphabet:string -> string -> int

(* Function to calculate the check digit that should be appended to the number *)
val calc_check_digit : ?alphabet:string -> string -> char

(* Function to validate the checksum of a number *)
val validate : ?alphabet:string -> string -> string

(* Function to check if a number is valid *)
val is_valid : string -> bool
