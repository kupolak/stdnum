(** Shared error type for stdnum validation functions. *)

type t =
  | Invalid_format
      (** The number has an invalid format or contains invalid characters. *)
  | Invalid_length  (** The number has an invalid length. *)
  | Invalid_checksum  (** The checksum or check digit validation failed. *)
  | Invalid_component
      (** A component of the number (e.g. country code, prefix) is invalid. *)

val to_string : t -> string
(** Convert an error to a human-readable string. *)
