(** Bitcoin address.

    A Bitcoin address is an identifier that is used as destination in a Bitcoin
    transaction. It is based on a hash of the public portion of a key pair.

    There are currently three address formats in use:
    - P2PKH: pay to pubkey hash (starts with "1")
    - P2SH: pay to script hash (starts with "3")
    - Bech32: segwit addresses (starts with "bc1")

    More information:
    - https://en.bitcoin.it/wiki/Address *)

exception Invalid_format
exception Invalid_length
exception Invalid_checksum
exception Invalid_component

val compact : string -> string
(** Convert the address to the minimal representation. This strips the address
    of any valid separators and removes surrounding whitespace. Bech32 addresses
    are converted to lowercase.

    Example: [compact "BC1QARDV855YJNGSPVXUTTQ897AQCA3LXJU2Y69JCE"] returns
    ["bc1qardv855yjngspvxuttq897aqca3lxju2y69jce"] *)

val validate : string -> string
(** Check if the address is valid. This checks the length and checksum. Returns
    the normalized address if valid.

    @raise Invalid_component if a component is invalid *)

val validate_result : string -> (string, Tools.Error.t) result
(** Same as {!validate} but returns a [result] instead of raising exceptions. *)

val is_valid : string -> bool
(** Check if the address is valid. Returns [true] if valid, [false] otherwise.
*)
