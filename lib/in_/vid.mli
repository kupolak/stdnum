(** VID (Indian personal virtual identity number).

    VID is a temporary, revocable 16-digit random number mapped with the Aadhaar
    number. VID is used in lieu of Aadhaar number whenever authentication or
    e-KYC services are performed.

    VID is made up of 16 digits where the last digits is a check digit
    calculated using the Verhoeff algorithm. The numbers are generated in a
    random, non-repeating sequence and do not begin with 0 or 1.

    More information:
    - https://uidai.gov.in/en/contact-support/have-any-question/284-faqs/aadhaar-online-services/virtual-id-vid.html
    - https://uidai.gov.in/images/resource/UIDAI_Circular_11012018.pdf *)

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
(** Check if the number provided is a valid VID number. This checks the length,
    formatting and check digit.

    @raise Invalid_format
      if the number contains invalid characters or starts with 0 or 1
    @raise Invalid_length if the length is not 16
    @raise Invalid_checksum if the checksum fails *)

val is_valid : string -> bool
(** Check if the number provided is a valid VID number. This checks the length,
    formatting and check digit. *)

val format : string -> string
(** Reformat the number to the standard presentation format. *)

val mask : string -> string
(** Masks the first 12 digits as per Ministry of Electronics and Information
    Technology (MeitY) guidelines. *)
