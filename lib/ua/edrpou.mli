(**
   ЄДРПОУ, EDRPOU (Identifier for enterprises and organizations in Ukraine).

   The ЄДРПОУ (Єдиного державного реєстру підприємств та організацій України,
   Unified State Register of Enterprises and Organizations of Ukraine) is a
   unique identification number of legal entities in Ukraine. The number
   consists of 8 digits, the last being a check digit.

   More information:
   * https://uk.wikipedia.org/wiki/Код_ЄДРПОУ
   * https://1cinfo.com.ua/Articles/Proverka_koda_po_EDRPOU.aspx
*)

exception Invalid_format
(** Exception raised for an invalid EDRPOU format. *)

exception Invalid_length
(** Exception raised for an invalid EDRPOU length. *)

exception Invalid_checksum
(** Exception raised for an invalid EDRPOU checksum. *)

val compact : string -> string
(** [compact number] converts the EDRPOU number to its minimal representation.
    @param number The EDRPOU number.
    @return The compacted EDRPOU number. *)

val calc_check_digit : string -> string
(** [calc_check_digit number] calculates the check digit for the EDRPOU number.
    @param number The EDRPOU number (first 7 digits).
    @return The check digit as a string. *)

val validate : string -> string
(** [validate number] checks if the EDRPOU number is valid.
    @param number The EDRPOU number to validate.
    @return The compacted EDRPOU number if valid.
    @raises Invalid_format if the format is invalid.
    @raises Invalid_length if the length is invalid.
    @raises Invalid_checksum if the checksum is invalid. *)

val is_valid : string -> bool
(** [is_valid number] checks if the EDRPOU number is valid.
    @param number The EDRPOU number to check.
    @return true if the EDRPOU number is valid, false otherwise. *)

val format : string -> string
(** [format number] reformats the EDRPOU number to the standard presentation format.
    @param number The EDRPOU number.
    @return The formatted EDRPOU number. *)
