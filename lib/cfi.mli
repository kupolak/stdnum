(** CFI (ISO 10962 Classification of Financial Instruments).

    The CFI is a 6-character code used to classify financial instruments. It is
    issued alongside an ISIN and describes category such as equity or future and
    category-specific properties such as underlying asset type or payment
    status.

    More information:
    - https://en.wikipedia.org/wiki/ISO_10962
    - https://www.iso.org/standard/73564.html
    - https://www.six-group.com/en/products-services/financial-information/data-standards.html
*)

exception Invalid_format
exception Invalid_length
exception Invalid_component

val compact : string -> string
(** Convert the code to the minimal representation. This strips the code of any
    valid separators and removes surrounding whitespace. Converts to uppercase.

    Example: [compact "eln ufr"] returns ["ELNUFR"] *)

val validate : string -> string
(** Check if the code is valid. This checks the length and format. Returns the
    normalized code if valid.

    @raise Invalid_component if a component is invalid *)

val validate_result : string -> (string, Tools.Error.t) result
(** Same as {!validate} but returns a [result] instead of raising exceptions. *)

val is_valid : string -> bool
(** Check if the code is valid. Returns [true] if valid, [false] otherwise. *)
