(** Handelsregisternummer (German company register number).

    The number consists of the court where the company has registered, the type
    of register and the registration number.

    The type of the register is either HRA or HRB where the letter "B" stands for
    HR section B, where limited liability companies and corporations are entered
    (GmbH's and AG's). There is also a section HRA for business partnerships
    (OHG's, KG's etc.). In other words: businesses in section HRB are limited
    liability companies, while businesses in HRA have personally liable partners.

    More information:
    - https://www.handelsregister.de/
    - https://en.wikipedia.org/wiki/German_Trade_Register
    - https://offeneregister.de/ *)

exception Invalid_format
exception Invalid_component

val compact : string -> string
(** Convert the number to the minimal representation. This strips the
    number of any valid separators and removes surrounding whitespace. *)

val validate : ?company_form:string -> string -> string
(** Check if the number is a valid company registry number. If a
    company_form (eg. GmbH or PartG) is given, the number is validated to
    have the correct registry type.
    @raise Invalid_format if the number format is invalid
    @raise Invalid_component if the court or registry type is invalid *)

val is_valid : string -> bool
(** Check if the number is a valid company registry number. *)
