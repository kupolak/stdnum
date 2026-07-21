(** NI (Número de identidad, Cuban identity card numbers).

    Número de carnet de identidad is the Cuban national identifier that is
    assigned to residents. The number consists of 11 digits and include the date
    of birth of the person and gender.

    More information:
    - https://www.postdata.club/issues/201609/es-usted-unico-en-cuba.html *)

exception Invalid_format
exception Invalid_length
exception Invalid_component

val compact : string -> string
(** Convert the number to the minimal representation. This strips surrounding
    whitespace and separation dash. *)

val get_birth_date : string -> int * int * int
(** Split the date parts from the number and return the date of birth (year,
    month, day). *)

val get_gender : string -> string
(** Get the gender (M/F) from the person's NI. *)

val validate : string -> string
(** Check if the number is a valid NI. This checks the length, formatting and
    date component.

    @raise Invalid_component if the date component is invalid *)

val validate_result : string -> (string, Tools.Error.t) result
(** Same as {!validate} but returns a [result] instead of raising exceptions. *)

val is_valid : string -> bool
(** Check if the number is a valid NI. *)
