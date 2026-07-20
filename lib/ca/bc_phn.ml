(** BC PHN (British Columbia Personal Health Number).

    A unique, numerical, lifetime identifier used in the specific identification
    of an individual client or patient who has had any interaction with the
    British Columbia health system. It is assigned only to and used by one person
    and will not be assigned to any other person.

    The existence of a PHN does not imply eligibility for health care services in
    BC or provide any indication of an individual’s benefit status.

    The PNH is a 10-digit number where the first digit is always 9, and the last
    digit is a MOD-11 check digit.

    More information:
    - https://www2.gov.bc.ca/gov/content/health/health-drug-coverage/msp/bc-residents/personal-health-identification
    - https://www2.gov.bc.ca/assets/gov/health/practitioner-pro/software-development-guidelines/conformance-standards/vol-4b-app-rules-client-registry.pdf *)

open Tools

exception Invalid_format
exception Invalid_length
exception Invalid_component
exception Invalid_checksum

let compact number =
  Utils.clean number "[ -]" |> String.trim

let calc_check_digit number =
  let weights = [| 2; 4; 8; 5; 10; 9; 7; 3 |] in
  let sum = ref 0 in
  for i = 0 to 7 do
    let digit = int_of_char number.[i] - int_of_char '0' in
    sum := !sum + ((weights.(i) * digit) mod 11)
  done;
  string_of_int ((11 - (!sum mod 11)) mod 11)

let validate number =
  let number = compact number in
  if String.length number <> 10 then raise Invalid_length;
  if not (Utils.is_digits number) then raise Invalid_format;
  if number.[0] <> '9' then raise Invalid_component;
  
  if String.sub number 9 1 <> calc_check_digit (String.sub number 1 8) then
    raise Invalid_checksum;
    
  number

let is_valid number =
  try
    ignore (validate number);
    true
  with Invalid_format | Invalid_length | Invalid_component | Invalid_checksum -> false

let format number =
  let number = compact number in
  String.sub number 0 4 ^ " " ^
  String.sub number 4 3 ^ " " ^
  String.sub number 7 3
