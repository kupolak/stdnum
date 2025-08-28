open Tools

exception Invalid_format
exception Invalid_length
exception Invalid_component
exception Invalid_checksum

let compact number =
  Utils.clean number "[ -/]" |> String.uppercase_ascii |> String.trim

(* Luhn algorithm for check digit validation *)
let luhn_validate number =
  if not (Utils.is_digits number) then raise Invalid_format;
  let len = String.length number in
  let sum = ref 0 in
  for i = 0 to len - 1 do
    let n = int_of_string (String.make 1 number.[len - 1 - i]) in
    let v =
      if i mod 2 = 1 then
        let d = n * 2 in
        if d > 9 then d - 9 else d
      else n
    in
    sum := !sum + v
  done;
  if !sum mod 10 <> 0 then raise Invalid_checksum

let validate number =
  let number = compact number in
  if String.length number <> 10 then raise Invalid_length;
  if not (Utils.is_digits number) then raise Invalid_format;
  (* According to references, allowed starting digits 0,1,2,3,9; be strict as given *)
  let first = number.[0] in
  if not (List.mem first [ '0'; '1'; '2'; '3'; '9' ]) then
    raise Invalid_component;
  luhn_validate number;
  number

let is_valid number =
  try
    ignore (validate number);
    true
  with
  | Invalid_format | Invalid_length | Invalid_component | Invalid_checksum ->
    false

let format number = compact number
