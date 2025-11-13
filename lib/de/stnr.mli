(** St.-Nr. (Steuernummer, German tax number).

    The Steuernummer (St.-Nr.) is a tax number assigned by regional tax offices
    to taxable individuals and organisations. The number is being replaced by the
    Steuerliche Identifikationsnummer (IdNr).

    The number has 10 or 11 digits for the regional form (per Bundesland) and 13
    digits for the number that is unique within Germany. The number consists of
    (part of) the Bundesfinanzamtsnummer (BUFA-Nr.), a district number, a serial
    number and a check digit.

    More information:
    - https://de.wikipedia.org/wiki/Steuernummer *)

exception Invalid_format
exception Invalid_length
exception Invalid_component

type region =
  | Baden_Wuerttemberg
  | Bayern
  | Berlin
  | Brandenburg
  | Bremen
  | Hamburg
  | Hessen
  | Mecklenburg_Vorpommern
  | Niedersachsen
  | Nordrhein_Westfalen
  | Rheinland_Pfalz
  | Saarland
  | Sachsen
  | Sachsen_Anhalt
  | Schleswig_Holstein
  | Thueringen

val compact : string -> string
(** Convert the number to the minimal representation. *)

val validate : ?region:region -> string -> string
(** Check if the number is a valid tax number. The region can be supplied to
    verify that the number is assigned in that region.
    @raise Invalid_format if the number format is invalid
    @raise Invalid_length if the number is not 10, 11, or 13 digits
    @raise Invalid_component if the region is invalid *)

val is_valid : ?region:region -> string -> bool
(** Check if the number is a valid tax number. *)

val guess_regions : string -> region list
(** Return a list of regions this number is valid for. *)

val to_regional_number : string -> string
(** Convert the number to a regional (10 or 11 digit) number.
    @raise Invalid_format if conversion fails *)

val to_country_number : ?region:region -> string -> string
(** Convert the number to the nationally unique number (13 digits).
    The region is needed if the number is not only valid for one particular region.
    @raise Invalid_format if the number format is invalid
    @raise Invalid_component if the region cannot be determined *)

val format : ?region:region -> string -> string
(** Reformat the passed number to the standard format. *)
