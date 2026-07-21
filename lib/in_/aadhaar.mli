(** Aadhaar (Indian personal identity number).

    Aadhaar is a 12 digit identification number that can be obtained by Indian
    citizens, non-residents passport holders of India and resident foreign
    nationals. The number is issued by the Unique Identification Authority of
    India (UIDAI).

    Aadhaar is made up of 12 digits where the last digits is a check digit
    calculated using the Verhoeff algorithm. The numbers are generated in a
    random, non-repeating sequence and do not begin with 0 or 1.

    More information:
    - https://en.wikipedia.org/wiki/Aadhaar
    - https://web.archive.org/web/20140611025606/http://uidai.gov.in/UID_PDF/Working_Papers/A_UID_Numbering_Scheme.pdf
*)

exception Invalid_format
(** Exception raised when the number has invalid format. *)

exception Invalid_length
(** Exception raised when the number has invalid length. *)

exception Invalid_checksum
(** Exception raised when the checksum validation fails. *)

val compact : string -> string
(** Convert the number to the minimal representation. This strips the number of
    any valid separators and removes surrounding whitespace. *)

val validate : string -> string
(** Check if the number provided is a valid Aadhaar number. This checks the
    length, formatting and check digit.

    @raise Invalid_format
      if the number contains invalid characters or starts with 0 or 1
    @raise Invalid_length if the length is not 12
    @raise Invalid_checksum if the checksum fails *)

val is_valid : string -> bool
(** Check if the number provided is a valid Aadhaar number. This checks the
    length, formatting and check digit. *)

val format : string -> string
(** Reformat the number to the standard presentation format. *)

val mask : string -> string
(** Masks the first 8 digits as per Ministry of Electronics and Information
    Technology (MeitY) guidelines. *)
