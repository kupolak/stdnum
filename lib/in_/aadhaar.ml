(** Aadhaar (Indian personal identity number).

    Aadhaar is a 12 digit identification number that can be obtained by Indian
    citizens, non-residents passport holders of India and resident foreign
    nationals. The number is issued by the Unique Identification Authority of
    India (UIDAI).

    Aadhaar is made up of 12 digits where the last digits is a check digit
    calculated using the Verhoeff algorithm. The numbers are generated in a
    random, non-repeating sequence and do not begin with 0 or 1.

    More information:
    - https://en.wikipedia.org/wiki/Aadhaar
    - https://web.archive.org/web/20140611025606/http://uidai.gov.in/UID_PDF/Working_Papers/A_UID_Numbering_Scheme.pdf
*)

open Tools

exception Invalid_format
exception Invalid_length
exception Invalid_checksum

let aadhaar_re =
  Str.regexp "^[2-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]$"

let compact number = Utils.clean number "[ -]" |> String.trim

let reverse_string s =
  let len = String.length s in
  let res = Bytes.create len in
  for i = 0 to len - 1 do
    Bytes.set res i s.[len - 1 - i]
  done;
  Bytes.to_string res

let validate number =
  let number = compact number in
  if String.length number <> 12 then raise Invalid_length;
  if not (Str.string_match aadhaar_re number 0) then raise Invalid_format;
  if number = reverse_string number then raise Invalid_format;
  if not (Verhoeff.is_valid number) then raise Invalid_checksum;
  number

let validate_result number =
  try Ok (validate number) with
  | Invalid_format -> Error Error.Invalid_format
  | Invalid_length -> Error Error.Invalid_length
  | Invalid_checksum -> Error Error.Invalid_checksum

let is_valid number =
  try
    ignore (validate number);
    true
  with Invalid_format | Invalid_length | Invalid_checksum -> false

let format number =
  let number = compact number in
  String.sub number 0 4 ^ " " ^ String.sub number 4 4 ^ " "
  ^ String.sub number 8 4

let mask number =
  let number = compact number in
  "XXXX XXXX " ^ String.sub number 8 4
