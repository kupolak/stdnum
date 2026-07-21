(** EC Number (European Community number).

    The EC Number is a unique seven-digit number assigned to chemical substances
    for regulatory purposes within the European Union by the European
    Commission.

    More information:
    - https://en.wikipedia.org/wiki/European_Community_number *)

exception Invalid_format
(** Exception raised when the number has invalid format. *)

exception Invalid_length
(** Exception raised when the number has invalid length. *)

exception Invalid_checksum
(** Exception raised when the checksum validation fails. *)

val compact : string -> string
(** Convert the number to the minimal representation. *)

val calc_check_digit : string -> string
(** Calculate the check digit for the number. The passed number should not have
    the check digit included. *)

val validate : string -> string
(** Check if the number provided is a valid EC Number.

    @raise Invalid_format if the number contains invalid characters
    @raise Invalid_length if the length is not 9
    @raise Invalid_checksum if the checksum fails *)

val is_valid : string -> bool
(** Check if the number provided is a valid EC Number. *)
