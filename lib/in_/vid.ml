(** VID (Indian personal virtual identity number).

    VID is a temporary, revocable 16-digit random number mapped with the Aadhaar number.
    VID is used in lieu of Aadhaar number whenever authentication or e-KYC services
    are performed.

    VID is made up of 16 digits where the last digits is a check digit
    calculated using the Verhoeff algorithm. The numbers are generated in a
    random, non-repeating sequence and do not begin with 0 or 1.

    More information:
    - https://uidai.gov.in/en/contact-support/have-any-question/284-faqs/aadhaar-online-services/virtual-id-vid.html
    - https://uidai.gov.in/images/resource/UIDAI_Circular_11012018.pdf *)

open Tools

exception Invalid_format
exception Invalid_length
exception Invalid_checksum

let vid_re = Str.regexp "^[2-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]$"

let compact number =
  Utils.clean number "[ -]" |> String.trim

let reverse_string s =
  let len = String.length s in
  let res = Bytes.create len in
  for i = 0 to len - 1 do
    Bytes.set res i s.[len - 1 - i]
  done;
  Bytes.to_string res

let validate number =
  let number = compact number in
  if String.length number <> 16 then raise Invalid_length;
  if not (Str.string_match vid_re number 0) then raise Invalid_format;
  if number = reverse_string number then raise Invalid_format;
  if not (Verhoeff.is_valid number) then raise Invalid_checksum;
  number

let is_valid number =
  try
    ignore (validate number);
    true
  with Invalid_format | Invalid_length | Invalid_checksum -> false

let format number =
  let number = compact number in
  String.sub number 0 4 ^ " " ^ String.sub number 4 4 ^ " " ^ String.sub number 8 4 ^ " " ^ String.sub number 12 4

let mask number =
  let number = compact number in
  "XXXX XXXX XXXX " ^ String.sub number 12 4
