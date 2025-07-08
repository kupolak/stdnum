open Tools

exception Invalid_format
exception Invalid_length
exception Invalid_checksum

let compact number = Utils.clean number "[ -]" |> String.trim

let calc_checksum number =
  let weights = [| 1; 2; 1; 2; 1; 2; 4; 1 |] in
  if String.length number <> Array.length weights then raise Invalid_length;

  (* Convert to numeric first, then sum individual digits *)
  let number_str = ref "" in
  for i = 0 to String.length number - 1 do
    let digit = int_of_string (String.make 1 number.[i]) in
    let weighted = weights.(i) * digit in
    number_str := !number_str ^ string_of_int weighted
  done;

  let sum = ref 0 in
  for i = 0 to String.length !number_str - 1 do
    sum := !sum + int_of_string (String.make 1 !number_str.[i])
  done;
  !sum mod 10

let validate number =
  let compact_number = compact number in

  if String.length compact_number <> 8 then raise Invalid_length;

  if not (Utils.is_digits compact_number) then raise Invalid_format;

  let checksum = calc_checksum compact_number in
  if not (checksum = 0 || (checksum = 9 && compact_number.[6] = '7')) then
    raise Invalid_checksum;

  compact_number

let is_valid number =
  try
    ignore (validate number);
    true
  with Invalid_format | Invalid_length | Invalid_checksum -> false

let format number = compact number
