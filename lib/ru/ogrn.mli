(** ОГРН, OGRN, PSRN, ОГРНИП, OGRNIP (Russian Primary State Registration
    Number).

    The ОГРН (Основной государственный регистрационный номер, Primary State
    Registration Number) is a Russian identifier for legal entities. The number
    consists of 13 or 15 digits and includes information on the type of
    organisation, the registration year and a tax inspection code. The 15 digit
    variant is called ОГРНИП (Основной государственный регистрационный номер
    индивидуального предпринимателя, Primary State Registration Number of an
    Individual Entrepreneur).

    More information:
    - https://ru.wikipedia.org/wiki/Основной_государственный_регистрационный_номер
    - https://ru.wikipedia.org/wiki/Основной_государственный_регистрационный_номер_индивидуального_предпринимателя
*)

exception Invalid_format
exception Invalid_length
exception Invalid_checksum
exception Invalid_component

val compact : string -> string
(** Convert the number to the minimal representation. This strips the number of
    any valid separators and removes surrounding whitespace. *)

val calc_check_digit : string -> string
(** Calculate the control digit of the OGRN based on its length. *)

val validate : string -> string
(** Determine if the given number is a valid OGRN. *)

val validate_result : string -> (string, Tools.Error.t) result
(** Same as {!validate} but returns a [result] instead of raising exceptions. *)

val is_valid : string -> bool
(** Check if the number is a valid OGRN. *)
