(** CC (Número de Cartão de Cidadão, Portuguese Identity number).

    The Portuguese Identity Number is alphanumeric and consists of the numeric
    Número de Identificação Civil, a two-letter version and a check digit.

    More information:
    - https://pt.wikipedia.org/wiki/Cartão_de_cidadão
    - https://www.autenticacao.gov.pt/documents/20126/115760/Validação+de+Número+de+Documento+do+Cartão+de+Cidadão.pdf *)

exception Invalid_format
(** Exception raised when the number has invalid format. *)

exception Invalid_length
(** Exception raised when the number has invalid length. *)

exception Invalid_checksum
(** Exception raised when the checksum validation fails. *)

val compact : string -> string
(** Convert the number to the minimal representation. This strips the
    number of any valid separators and removes surrounding whitespace. *)

val calc_check_digit : string -> string
(** Calculate the check digit for the number. *)

val validate : string -> string
(** Check if the number is a valid cartao de cidadao number. *)

val is_valid : string -> bool
(** Check if the number is a valid cartao de cidadao number. *)

val format : string -> string
(** Reformat the number to the standard presentation format. *)
