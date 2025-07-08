(*
UBN (Unified Business Number, 統一編號, Taiwanese tax number).

The Unified Business Number (UBN, 統一編號) is the number assigned to businesses
within Taiwan for tax (VAT) purposes. The number consists of 8 digits, the
last being a check digit.

More information:
* https://zh.wikipedia.org/wiki/統一編號
* https://findbiz.nat.gov.tw/fts/query/QueryBar/queryInit.do?request_locale=en
*)

exception Invalid_format
exception Invalid_length
exception Invalid_checksum

val compact : string -> string
(** Convert the number to the minimal representation. *)

val calc_checksum : string -> int
(** Calculate the checksum over the number. *)

val validate : string -> string
(** Check if the number is a valid Taiwan UBN number. *)

val is_valid : string -> bool
(** Check if the number is a valid Taiwan UBN number. *)

val format : string -> string
(** Reformat the number to the standard presentation format. *)
