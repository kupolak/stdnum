(** GSTIN (Goods and Services Tax identification number, Indian VAT number).

    The Goods and Services Tax identification number (GSTIN) is a 15 digit
    unique identifier assigned to all business entities in India registered
    under the Goods and Services Tax (GST) Act, 2017.

    Each GSTIN begins with a 2 digit state code, the next 10 characters are the
    holder's PAN, the 13th character is an alphanumeric digit that represents
    the number of GSTIN registrations made in a state or union territory for
    same the PAN, the 14th character is 'Z' and the last character is an
    alphanumeric check digit calculated using Luhn mod 36 algorithm.

    More information:
    - https://bajajfinserv.in/insights/what-is-goods-and-service-tax-identification-number
    - https://ddvat.gov.in/docs/List%20of%20State%20Code.pdf
    - https://en.wikipedia.org/wiki/Goods_and_Services_Tax_(India) *)

open Tools

exception Invalid_format
exception Invalid_length
exception Invalid_component
exception Invalid_checksum

let gstin_re =
  Str.regexp
    "^[0-9][0-9][A-Z][A-Z][A-Z][A-Z][A-Z][0-9][0-9][0-9][0-9][A-Z][0-9A-Z][0-9A-Z][0-9A-Z]$"

let alphabet = "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ"

let state_codes =
  [
    ("01", "Jammu and Kashmir")
  ; ("02", "Himachal Pradesh")
  ; ("03", "Punjab")
  ; ("04", "Chandigarh")
  ; ("05", "Uttarakhand")
  ; ("06", "Haryana")
  ; ("07", "Delhi")
  ; ("08", "Rajasthan")
  ; ("09", "Uttar Pradesh")
  ; ("10", "Bihar")
  ; ("11", "Sikkim")
  ; ("12", "Arunachal Pradesh")
  ; ("13", "Nagaland")
  ; ("14", "Manipur")
  ; ("15", "Mizoram")
  ; ("16", "Tripura")
  ; ("17", "Meghalaya")
  ; ("18", "Assam")
  ; ("19", "West Bengal")
  ; ("20", "Jharkhand")
  ; ("21", "Orissa")
  ; ("22", "Chattisgarh")
  ; ("23", "Madhya Pradesh")
  ; ("24", "Gujarat")
  ; ("25", "Daman and Diu")
  ; ("26", "Dadar and Nagar Haveli")
  ; ("27", "Maharashtra")
  ; ("28", "Andhra Pradesh")
  ; ("29", "Karnataka")
  ; ("30", "Goa")
  ; ("31", "Lakshadweep")
  ; ("32", "Kerala")
  ; ("33", "Tamil Nadu")
  ; ("34", "Puducherry")
  ; ("35", "Anadaman and Nicobar Islands")
  ; ("36", "Telangana")
  ; ("37", "Andhra Pradesh (New)")
  ]

let compact number =
  Utils.clean number "[ -]" |> String.trim |> String.uppercase_ascii

let get_alphabet_index c = try String.index alphabet c with Not_found -> 0

type gstin_info = {
    state : string option
  ; pan : string
  ; holder_type : string
  ; initial : string
  ; registration_count : int
}

let to_pan number =
  let number = compact number in
  String.sub number 2 10

let validate number =
  let number = compact number in
  if String.length number <> 15 then raise Invalid_length;
  if not (Str.string_match gstin_re number 0) then raise Invalid_format;
  let state_code = String.sub number 0 2 in
  if
    (not (List.mem_assoc state_code state_codes))
    || number.[12] = '0'
    || number.[13] <> 'Z'
  then raise Invalid_component;
  ignore (Pan.validate (to_pan number));
  if not (Luhn.is_valid ~alphabet number) then raise Invalid_checksum;
  number

let validate_result number =
  try Ok (validate number) with
  | Invalid_format -> Error Error.Invalid_format
  | Invalid_length -> Error Error.Invalid_length
  | Invalid_component -> Error Tools.Error.Invalid_component
  | Invalid_checksum -> Error Error.Invalid_checksum

let is_valid number =
  try
    ignore (validate number);
    true
  with
  | Invalid_format | Invalid_length | Invalid_component | Invalid_checksum
  | Pan.Invalid_format | Pan.Invalid_length | Pan.Invalid_component
  ->
    false

let info number =
  let number = validate number in
  let pan_str = to_pan number in
  let holder, _ = Pan.info pan_str in
  {
    state = List.assoc_opt (String.sub number 0 2) state_codes
  ; pan = pan_str
  ; holder_type = holder
  ; initial = String.make 1 number.[6]
  ; registration_count = get_alphabet_index number.[12]
  }
