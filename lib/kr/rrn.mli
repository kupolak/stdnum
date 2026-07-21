(** RRN (South Korean resident registration number).

    The RRN (resident registration number, 주민등록번호) is a 13-digit number issued
    to all residents of the Republic of Korea. Foreigners residing in the
    Republic of Korea receive an alien registration number (ARN) which follows
    the same encoding pattern.

    The first six digits code the date of birth. The seventh digit encodes the
    century and gender. The next four digits encode the place of birth for
    Koreans or the issuing agency for foreigners, followed by two digits for the
    community center number, one serial number and a check digit.

    More information:
    - https://www.law.go.kr/lsSc.do?tabMenuId=tab18&p1=&subMenu=1&nwYn=1&section=&tabNo=&query=개인정보+보호법
    - https://en.wikipedia.org/wiki/Resident_registration_number
    - https://techscience.org/a/2015092901/ *)

exception Invalid_format
(** Exception raised when the number has invalid format. *)

exception Invalid_length
(** Exception raised when the number has invalid length. *)

exception Invalid_component
(** Exception raised when a component of the number is invalid. *)

exception Invalid_checksum
(** Exception raised when the checksum validation fails. *)

val compact : string -> string
(** Convert the number to the minimal representation. This strips the number of
    any valid separators and removes surrounding whitespace. *)

val calc_check_digit : string -> string
(** Calculate the check digit. *)

val get_birth_date : ?allow_future:bool -> string -> int * int * int
(** Split the date parts from the number and return the birth date. If
    allow_future is False birth dates in the future are rejected. *)

val validate : ?allow_future:bool -> string -> string
(** Check if the number is a valid RNN. This checks the length, formatting and
    check digit. If allow_future is False birth dates in the future are
    rejected.

    @raise Invalid_format if the number contains invalid characters
    @raise Invalid_length if the length is not 13
    @raise Invalid_component if the date or place of birth is invalid
    @raise Invalid_checksum if the checksum fails *)

val is_valid : ?allow_future:bool -> string -> bool
(** Check if the number provided is valid. *)

val format : string -> string
(** Reformat the number to the standard presentation format. *)
