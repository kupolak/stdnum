(*
MF (Matricule Fiscal, Tunisia tax number).

The MF consists of 4 parts: the "identifiant fiscal", the "code TVA", the "code
catégorie" and the "numéro d'etablissement secondaire".

The "identifiant fiscal" consists of 2 parts: the "identifiant unique" and the
"clef de contrôle". The "identifiant unique" is composed of 7 digits. The "clef
de contrôle" is a letter, excluding "I", "O" and "U" because of their
similarity to "1", "0" and "4".

The "code TVA" is a letter that tells which VAT regime is being used. The valid
values are "A", "P", "B", "D" and "N".

The "code catégorie" is a letter that tells the category the contributor
belongs to. The valid values are "M", "P", "C", "N" and "E".

The "numéro d'etablissement secondaire" consists of 3 digits. It is usually
"000", but it can be "001", "002"... depending on the branches. If it is not
"000" then "code catégorie" must be "E".

More information:

* https://futurexpert.tn/2019/10/22/structure-et-utilite-du-matricule-fiscal/
* https://www.registre-entreprises.tn/
*)

exception Invalid_length
(** Exception raised when the MF number has an invalid length. *)

exception Invalid_format
(** Exception raised when the MF number has an invalid format. *)

val validate : string -> string
(** Check if the number is a valid Tunisia MF number. This checks the length
    and formatting. Returns the normalized number if valid.
    @raise Invalid_length if the number length is not 8 or 13
    @raise Invalid_format if the number has invalid format or characters *)

val is_valid : string -> bool
(** Check if the number is a valid Tunisia MF number.
    Returns true if valid, false otherwise. *)

val format : string -> string
(** Reformat the number to the standard presentation format with slashes. *)

val compact : string -> string
(** [compact number] removes spaces, slashes, dots and dashes from the number,
    converts to uppercase, and zero-pads the serial to 7 digits. *)
