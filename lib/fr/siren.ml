open Tools

exception Invalid_checksum
exception Invalid_length
exception Invalid_format

let compact number = Utils.clean number "[ .-]" |> String.trim

let validate number =
  let number = compact number in

  (* Check length *)
  if String.length number <> 9 then raise Invalid_length;

  (* Check all digits *)
  if not (Utils.is_digits number) then raise Invalid_format;

  (* Validate using Luhn algorithm *)
  (try ignore (Luhn.validate number)
   with Luhn.Invalid_checksum -> raise Invalid_checksum);

  number

let is_valid number =
  try
    ignore (validate number);
    true
  with Invalid_checksum | Invalid_length | Invalid_format -> false

let to_tva number =
  (* Calculate the two check digits and prepend to SIREN *)
  let siren_compact = compact number in
  let check_value = int_of_string (siren_compact ^ "12") mod 97 in
  let separator = if String.contains number ' ' then " " else "" in
  Printf.sprintf "%02d%s%s" check_value separator number

let format ?(separator = " ") number =
  let number = compact number in
  let part1 = String.sub number 0 3 in
  let part2 = String.sub number 3 3 in
  let part3 = String.sub number 6 3 in
  String.concat separator [ part1; part2; part3 ]
