open Tools

exception Invalid_length
exception Invalid_format
exception Invalid_component
exception Invalid_checksum

let compact number =
  Utils.clean number "[ -]" |> String.uppercase_ascii |> String.trim

(* Known number types and their corresponding value in the check digit calculation *)
let company_types =
  [
    ('V', 4)
  ; (* natural person born in Venezuela *)
    ('E', 8)
  ; (* foreign natural person *)
    ('J', 12)
  ; (* company *)
    ('P', 16)
  ; (* passport *)
    ('G', 20) (* government *)
  ]

let get_company_type_value c =
  try List.assoc c company_types
  with Not_found -> failwith "Invalid company type"

let calc_check_digit number =
  let number = compact number in
  let weights = [| 3; 2; 7; 6; 5; 4; 3; 2 |] in
  let check_digit_lookup = "00987654321" in
  let c = get_company_type_value number.[0] in
  let total = ref c in
  let len = min (String.length number) 9 in
  for i = 1 to len - 1 do
    let digit = int_of_char number.[i] - int_of_char '0' in
    total := !total + (weights.(i - 1) * digit)
  done;
  String.make 1 check_digit_lookup.[!total mod 11]

let validate number =
  let number = compact number in
  if String.length number <> 10 then raise Invalid_length;
  if not (List.mem_assoc number.[0] company_types) then raise Invalid_component;
  let digits_part = String.sub number 1 9 in
  if not (Utils.is_digits digits_part) then raise Invalid_format;
  let calculated_check_digit = calc_check_digit number in
  if String.get number 9 <> String.get calculated_check_digit 0 then
    raise Invalid_checksum;
  number

let validate_result number =
  try Ok (validate number) with
  | Invalid_length -> Error Error.Invalid_length
  | Invalid_format -> Error Error.Invalid_format
  | Invalid_component -> Error Tools.Error.Invalid_component
  | Invalid_checksum -> Error Error.Invalid_checksum

let is_valid number = Result.is_ok (validate_result number)
