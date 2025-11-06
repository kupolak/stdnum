open Tools

exception Invalid_length
exception Invalid_format
exception Invalid_checksum

let compact number = Utils.clean number "[ -.]" |> String.trim

(* Luhn checksum algorithm *)
let luhn_checksum number =
  let total = ref 0 in
  let len = String.length number in
  for i = 0 to len - 1 do
    let digit = int_of_char number.[i] - int_of_char '0' in
    let value =
      if (len - i) mod 2 = 0 then
        (* Double every other digit (from right to left, even positions) *)
        let doubled = digit * 2 in
        if doubled > 9 then doubled - 9 else doubled
      else digit
    in
    total := !total + value
  done;
  !total mod 10

let validate number =
  let number = compact number in
  if not (Utils.is_digits number) then raise Invalid_format;
  if String.length number <> 10 then raise Invalid_length;
  if luhn_checksum number <> 0 then raise Invalid_checksum;
  number

let is_valid number =
  try
    ignore (validate number);
    true
  with Invalid_format | Invalid_length | Invalid_checksum -> false

let format number =
  let number = compact number in
  String.sub number 0 6 ^ "-" ^ String.sub number 6 4
