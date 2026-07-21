(** VAT (Идентификационен номер по ДДС, Bulgarian VAT number).

    The Bulgarian VAT (Данък върху добавената стойност) number is either 9 (for
    legal entities) or 10 digits (for physical persons, foreigners and others)
    long. Each type of number has its own check digit algorithm.

    More information:
    - https://en.wikipedia.org/wiki/VAT_identification_number *)

open Tools

exception Invalid_format
exception Invalid_length
exception Invalid_checksum

let compact number =
  let number =
    Utils.clean number "[ -.]" |> String.trim |> String.uppercase_ascii
  in
  if String.starts_with ~prefix:"BG" number then
    String.sub number 2 (String.length number - 2)
  else number

let calc_check_digit_legal number =
  let sum1 = ref 0 in
  for i = 0 to 7 do
    let digit = int_of_char number.[i] - int_of_char '0' in
    sum1 := !sum1 + ((i + 1) * digit)
  done;
  let check = !sum1 mod 11 in
  let check =
    if check = 10 then begin
      let sum2 = ref 0 in
      for i = 0 to 7 do
        let digit = int_of_char number.[i] - int_of_char '0' in
        sum2 := !sum2 + ((i + 3) * digit)
      done;
      !sum2 mod 11
    end
    else check
  in
  string_of_int (check mod 10)

let calc_check_digit_other number =
  let weights = [| 4; 3; 2; 7; 6; 5; 4; 3; 2 |] in
  let sum = ref 0 in
  for i = 0 to 8 do
    let digit = int_of_char number.[i] - int_of_char '0' in
    sum := !sum + (weights.(i) * digit)
  done;
  let check = (11 - (!sum mod 11)) mod 11 in
  string_of_int check

let validate number =
  let number = compact number in
  if not (Utils.is_digits number) then raise Invalid_format;

  let len = String.length number in
  if len = 9 then begin
    if calc_check_digit_legal (String.sub number 0 8) <> String.sub number 8 1
    then raise Invalid_checksum
  end
  else if len = 10 then begin
    let is_egn_valid = Egn.is_valid number in
    let is_pnf_valid = Pnf.is_valid number in
    if
      (not is_egn_valid) && (not is_pnf_valid)
      && calc_check_digit_other (String.sub number 0 9) <> String.sub number 9 1
    then raise Invalid_checksum
  end
  else raise Invalid_length;

  number

let is_valid number =
  try
    ignore (validate number);
    true
  with Invalid_format | Invalid_length | Invalid_checksum -> false
