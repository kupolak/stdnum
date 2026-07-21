(** IMSI (International Mobile Subscriber Identity).

    The IMSI (International Mobile Subscriber Identity) is used to identify
    mobile phone users (the SIM). *)

exception Invalid_format
(** Exception raised when the number has invalid format. *)

exception Invalid_length
(** Exception raised when the number has invalid length. *)

exception Invalid_component
(** Exception raised when a component of the number is invalid. *)

val compact : string -> string
(** Convert the IMSI number to the minimal representation. *)

val validate : string -> string
(** Check if the number provided is a valid IMSI.

    @raise Invalid_format if the number contains invalid characters
    @raise Invalid_length if the length is not 14 or 15 *)

val is_valid : string -> bool
(** Check if the number provided is a valid IMSI. *)
