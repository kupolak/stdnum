(** IMEI (International Mobile Equipment Identity).

    The IMEI is used to identify mobile phones. An IMEI is 14, 15 (when the
    check digit is included) or 16 digits (IMEISV) long. The check digit is
    validated using the Luhn algorithm.

    More information:
    - https://en.wikipedia.org/wiki/International_Mobile_Equipment_Identity *)

open Tools

exception Invalid_format
exception Invalid_length
exception Invalid_checksum

let compact number =
  Utils.clean number "[ -]" |> String.trim |> String.uppercase_ascii

let validate number =
  let number = compact number in

  (* Check that all characters are digits *)
  if not (Utils.is_digits number) then raise Invalid_format;

  let len = String.length number in
  if len = 15 then
    (* Only 15-digit IMEI has check digit *)
    try ignore (Luhn.validate number)
    with Luhn.Invalid_checksum -> raise Invalid_checksum
  else if len <> 14 && len <> 16 then
    (* Neither IMEI without check digit nor IMEISV *)
    raise Invalid_length;

  number

let imei_type number =
  try
    let number = validate number in
    let len = String.length number in
    if len = 14 || len = 15 then Some "IMEI" else Some "IMEISV"
  with Invalid_format | Invalid_length | Invalid_checksum -> None

let is_valid number =
  try
    ignore (validate number);
    true
  with Invalid_format | Invalid_length | Invalid_checksum -> false

let split number =
  let number = compact number in
  let tac = String.sub number 0 (min 8 (String.length number)) in
  let serial =
    if String.length number > 8 then
      String.sub number 8 (min 6 (String.length number - 8))
    else ""
  in
  let rest =
    if String.length number > 14 then
      String.sub number 14 (String.length number - 14)
    else ""
  in
  (tac, serial, rest)

let format ?(separator = "-") ?(add_check_digit = false) number =
  let number = compact number in
  let number =
    if String.length number = 14 && add_check_digit then
      number ^ Luhn.calc_check_digit number
    else number
  in
  let p1 = String.sub number 0 (min 2 (String.length number)) in
  let p2 =
    if String.length number > 2 then
      String.sub number 2 (min 6 (String.length number - 2))
    else ""
  in
  let p3 =
    if String.length number > 8 then
      String.sub number 8 (min 6 (String.length number - 8))
    else ""
  in
  let p4 =
    if String.length number > 14 then
      String.sub number 14 (String.length number - 14)
    else ""
  in
  let parts = List.filter (fun s -> String.length s > 0) [ p1; p2; p3; p4 ] in
  String.concat separator parts
