(** CFI (ISO 10962 Classification of Financial Instruments).

    The CFI is a 6-character code used to classify financial instruments. It is
    issued alongside an ISIN and describes category such as equity or future and
    category-specific properties such as underlying asset type or payment status.

    More information:
    - https://en.wikipedia.org/wiki/ISO_10962
    - https://www.iso.org/standard/73564.html
    - https://www.six-group.com/en/products-services/financial-information/data-standards.html *)

exception Invalid_format
(** Exception raised when the CFI code has invalid format. *)

exception Invalid_length
(** Exception raised when the CFI code has invalid length. *)

exception Invalid_component
(** Exception raised when a component of the CFI code is invalid. *)

val compact : string -> string
(** Convert the code to the minimal representation. This strips the
    code of any valid separators and removes surrounding whitespace.
    Converts to uppercase.

    Example: [compact "eln ufr"] returns ["ELNUFR"] *)

val validate : string -> string
(** Check if the code is valid. This checks the length and format.
    Returns the normalized code if valid.

    @raise Invalid_format if the code contains invalid characters
    @raise Invalid_length if the code has invalid length (must be 6 characters)
    @raise Invalid_component if a component is invalid *)

val is_valid : string -> bool
(** Check if the code is valid.
    Returns [true] if valid, [false] otherwise. *)
