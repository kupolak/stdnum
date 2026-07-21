(** PVM (Pridėtinės vertės mokestis mokėtojo kodas, Lithuanian VAT number).

    The PVM is used for VAT purposes in Lithuania. It is 9 digits (for legal
    entities) or 12 digits long (for temporarily registered taxpayers). This
    module does not check the format of Lithuanian personal codes (Asmens
    kodas). *)

open Tools

exception Invalid_format
exception Invalid_length
exception Invalid_component
exception Invalid_checksum

let compact number =
  let number =
    Utils.clean number "[ -]" |> String.trim |> String.uppercase_ascii
  in
  if String.starts_with ~prefix:"LT" number then
    String.sub number 2 (String.length number - 2)
  else number

let calc_check_digit number =
  let len = String.length number in
  let check = ref 0 in
  for i = 0 to len - 1 do
    check :=
      !check + ((1 + (i mod 9)) * (int_of_char number.[i] - int_of_char '0'))
  done;
  let check1 = !check mod 11 in
  if check1 = 10 then (
    let check2 = ref 0 in
    for i = 0 to len - 1 do
      check2 :=
        !check2
        + ((1 + ((i + 2) mod 9)) * (int_of_char number.[i] - int_of_char '0'))
    done;
    string_of_int (!check2 mod 11 mod 10))
  else string_of_int check1

let validate number =
  let number = compact number in
  if not (Utils.is_digits number) then raise Invalid_format;
  let len = String.length number in
  if len = 9 then (if number.[7] <> '1' then raise Invalid_component)
  else if len = 12 then (if number.[10] <> '1' then raise Invalid_component)
  else raise Invalid_length;
  if
    String.make 1 number.[len - 1]
    <> calc_check_digit (String.sub number 0 (len - 1))
  then raise Invalid_checksum;
  number

let is_valid number =
  try
    ignore (validate number);
    true
  with
  | Invalid_format | Invalid_length | Invalid_component | Invalid_checksum ->
    false
