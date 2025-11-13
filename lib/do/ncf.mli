(** NCF (Números de Comprobante Fiscal, Dominican Republic receipt number).

    The NCF is used to number invoices and other documents for the purpose of tax
    filing. The number is either 19, 11 or 13 (e-CF) digits long. *)

exception Invalid_format
exception Invalid_length
exception Invalid_component

val compact : string -> string
(** Convert the number to the minimal representation. This strips the
    number of any valid separators and removes surrounding whitespace. *)

val validate : string -> string
(** Check if the number provided is a valid NCF.
    Raises Invalid_format, Invalid_length, or Invalid_component if invalid. *)

val is_valid : string -> bool
(** Check if the number provided is a valid NCF. *)
