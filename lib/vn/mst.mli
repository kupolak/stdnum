(*
MST (Mã số thuế, Vietnam tax number).

This number consists of 10 digits. Branches have a 13 digit number,
where the first ten digits are the same as the parent company's.

The first two digits is the province code where the business was
established. If an enterprise relocates its head office from one
province to another, the MST will remain unchanged.

The following seven digits are a sequential number from 0000001 to
9999999.

The tenth digit is the check digit for the first nine digits, which is
used to verify the number was correctly typed.

The last optional three digits are a sequence from 001 to 999
indicating branches of the enterprise. These digits are usually
separated from the first ten digits using a dash (-)

More information:

* https://vi.wikipedia.org/wiki/Thuế_Việt_Nam#Mã_số_thuế_(MST)_của_doanh_nghiệp
* https://easyinvoice.vn/ma-so-thue/
* https://ub.com.vn/threads/huong-dan-tra-cuu-ma-so-thue-doanh-nghiep-moi-nhat.261393/
*)

exception Invalid_length
exception Invalid_format
exception Invalid_component
exception Invalid_checksum

val compact : string -> string
(** [compact number] converts the number to the minimal representation.
    This strips the number of any valid separators and removes surrounding
    whitespace. *)

val calc_check_digit : string -> string
(** [calc_check_digit number] calculates the check digit for the first 9 digits. *)

val validate : string -> string
(** [validate number] checks if the number is a valid Vietnam MST number.
    This checks the length, formatting and check digit. *)

val is_valid : string -> bool
(** [is_valid number] checks if the number is a valid Vietnam MST number. *)

val format : string -> string
(** [format number] reformats the number to the standard presentation format. *)
