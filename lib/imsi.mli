(** IMSI (International Mobile Subscriber Identity).

    The IMSI (International Mobile Subscriber Identity) is used to identify
    mobile phone users (the SIM). *)

exception Invalid_format
exception Invalid_length
exception Invalid_component

val compact : string -> string
(** Convert the IMSI number to the minimal representation. *)

val validate : string -> string
(** Check if the number provided is a valid IMSI.

    @raise Invalid_length if the length is not 14 or 15 *)

val validate_result : string -> (string, Tools.Error.t) result
(** Same as {!validate} but returns a [result] instead of raising exceptions. *)

val is_valid : string -> bool
(** Check if the number provided is a valid IMSI. *)
