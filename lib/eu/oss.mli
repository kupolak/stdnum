(** OSS (European VAT on e-Commerce - One Stop Shop).

    This covers number that have been issued under the non-union scheme and the
    import scheme of the European VAT on e-Commerce one stop shop. Numbers under
    the non-union scheme are assigned to foreign companies providing digital
    services to European Union consumers. Numbers under the import scheme are
    assigned for importing goods from a third country (through an intermediary).

    This is also called MOSS (mini One Stop Shop) and VoeS (VAT on e-Services).
    The number under the import scheme is also called IOSS (Import One Stop Shop)
    number.

    Numbers under the non-union scheme are in the format EUxxxyyyyyz. For the
    import scheme the format is IMxxxyyyyyyz. An intermediary will also get an
    number in the format INxxxyyyyyyz but that may not be used as VAT
    identification number.

    More information:
    - https://vat-one-stop-shop.ec.europa.eu/one-stop-shop/register-oss_en *)

exception Invalid_format
(** Exception raised when the number has invalid format. *)

exception Invalid_length
(** Exception raised when the number has invalid length. *)

exception Invalid_component
(** Exception raised when the prefix or country code component is invalid. *)

val compact : string -> string
(** Compact European VAT Number *)

val validate : string -> string
(** Validate European VAT Number.

    @raise Invalid_format if the number contains invalid characters
    @raise Invalid_length if the length is incorrect
    @raise Invalid_component if the country code or prefix is invalid *)

val is_valid : string -> bool
(** Check if the number is a valid VAT number. This performs the
    country-specific check for the number. *)
