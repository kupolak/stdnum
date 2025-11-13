(** ESR, ISR, QR-reference (reference number on Swiss payment slips).

    The ESR (Eizahlungsschein mit Referenznummer), ISR (In-payment Slip with
    Reference Number) or QR-reference refers to the orange payment slip in
    Switzerland with which money can be transferred to an account. The slip
    contains a machine-readable part that contains a participant number and
    reference number. The participant number ensures the crediting to the
    corresponding account. The reference number enables the creditor to identify
    the invoice recipient. In this way, the payment process can be handled
    entirely electronically.

    The number consists of 26 numerical characters followed by a Modulo 10
    recursive check digit. It is printed in blocks of 5 characters (beginning
    with 2 characters, then 5x5-character groups). Leading zeros digits can be
    omitted.

    More information:
    - https://www.paymentstandards.ch/dam/downloads/ig-qr-bill-en.pdf *)

open Tools

exception Invalid_format
exception Invalid_length
exception Invalid_checksum

let compact number =
  let cleaned = Utils.clean number "[ ]" in
  (* Remove leading zeros *)
  let rec remove_leading_zeros s =
    if String.length s > 0 && s.[0] = '0' then
      remove_leading_zeros (String.sub s 1 (String.length s - 1))
    else s
  in
  remove_leading_zeros cleaned

let calc_check_digit number =
  let digits = [| 0; 9; 4; 6; 8; 2; 7; 1; 3; 5 |] in
  let c = ref 0 in
  (* Just clean spaces, but don't remove leading zeros *)
  let num = Utils.clean number "[ ]" in
  for i = 0 to String.length num - 1 do
    let digit = int_of_char num.[i] - int_of_char '0' in
    c := digits.((digit + !c) mod 10)
  done;
  string_of_int ((10 - !c) mod 10)

let validate number =
  let number = compact number in
  if String.length number > 27 then raise Invalid_length;
  if not (Utils.is_digits number) then raise Invalid_format;
  (if String.length number > 0 then
     let check_pos = String.length number - 1 in
     let calculated = calc_check_digit (String.sub number 0 check_pos) in
     if String.make 1 number.[check_pos] <> calculated then
       raise Invalid_checksum);
  number

let is_valid number =
  try
    ignore (validate number);
    true
  with Invalid_format | Invalid_length | Invalid_checksum -> false

let format number =
  let num = compact number in
  (* Pad to 27 digits with leading zeros *)
  let padded =
    let len = String.length num in
    if len < 27 then String.make (27 - len) '0' ^ num else num
  in
  (* Format as: XX XXXXX XXXXX XXXXX XXXXX XXXXX *)
  let parts = ref [ String.sub padded 0 2 ] in
  for i = 0 to 4 do
    let start = 2 + (i * 5) in
    parts := !parts @ [ String.sub padded start 5 ]
  done;
  String.concat " " !parts
