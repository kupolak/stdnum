(** UTR (United Kingdom Unique Taxpayer Reference).

    A UTR (unique taxpayer reference) is a 10 digit number used to identify UK
    taxpayers who have to submit a tax return.

    More information:
    - https://www.oecd.org/tax/automatic-exchange/crs-implementation-and-assistance/tax-identification-numbers/UK-TIN.pdf *)

open Tools

exception Invalid_format
exception Invalid_length
exception Invalid_checksum

let compact number =
  let number = Utils.clean number "[ ]" |> String.trim |> String.uppercase_ascii in
  let rec strip_k s =
    if String.length s > 0 && s.[0] = 'K' then
      strip_k (String.sub s 1 (String.length s - 1))
    else s
  in
  strip_k number

let calc_check_digit number =
  let weights = [| 6; 7; 8; 9; 10; 5; 4; 3; 2 |] in
  let sum = ref 0 in
  for i = 0 to 8 do
    let digit = int_of_char number.[i] - int_of_char '0' in
    sum := !sum + (digit * weights.(i))
  done;
  let idx = !sum mod 11 in
  let lookup = "21987654321" in
  String.make 1 lookup.[idx]

let validate number =
  let number = compact number in
  if not (Utils.is_digits number) then raise Invalid_format;
  if String.length number <> 10 then raise Invalid_length;
  if String.sub number 0 1 <> calc_check_digit (String.sub number 1 9) then
    raise Invalid_checksum;
  number

let is_valid number =
  try
    ignore (validate number);
    true
  with Invalid_format | Invalid_length | Invalid_checksum -> false
