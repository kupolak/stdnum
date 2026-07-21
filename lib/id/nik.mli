(** NIK (Nomor Induk Kependudukan, Indonesian identity number).

    The Nomor Induk Kependudukan (NIK, Population Identification Number,
    sometimes known as Nomor Kartu Tanda Penduduk or Nomor KTP) is issued to
    Indonesian citizens.

    The number consists of 16 digits in the format PPRRSSDDMMYYXXXX where PPRRSS
    (province, city/district, sub-district) indicates the place of residence
    when the number was issued. It is followed by a DDMMYY date of birth (for
    female 40 is added to the day). The last 4 digits are used to make the
    number unique.

    More information:
    - https://id.wikipedia.org/wiki/Nomor_Induk_Kependudukan *)

exception Invalid_format
exception Invalid_length
exception Invalid_component

val compact : string -> string
(** Convert the number to the minimal representation. *)

val get_birth_date : string -> int * int * int
(** Get the birth date from the person's NIK. *)

val check_registration_place : string -> string
(** Use the number to look up the place of registration of the person. *)

val validate : string -> string
(** Check if the number is a valid Indonesian NIK.

    @raise Invalid_component if the date or place is invalid *)

val validate_result : string -> (string, Tools.Error.t) result
(** Same as {!validate} but returns a [result] instead of raising exceptions. *)

val is_valid : string -> bool
(** Check if the number is a valid Indonesian NIK. *)
