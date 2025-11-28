open Tools

exception Invalid_checksum
exception Invalid_length
exception Invalid_format

let compact number =
  Utils.clean number "[ ]" |> String.uppercase_ascii |> String.trim

let calc_check_digit number =
  let number = compact number in
  (* Alphabet mapping: 0-9 stay as is, A-Z get special values *)
  let alphabet = "0123456789A BCDEFGHIJK LMNOPQRSTU VWXYZ" in
  let char_value c =
    try
      (* Find the character in the alphabet string *)
      let rec find_index idx =
        if idx >= String.length alphabet then raise Not_found
        else if alphabet.[idx] = c then idx
        else if alphabet.[idx] = ' ' then find_index (idx + 1)
        else find_index (idx + 1)
      in
      find_index 0
    with Not_found -> 0
  in
  let sum = ref 0 in
  for i = 0 to String.length number - 1 do
    let value = char_value number.[i] in
    let power = 1 lsl i in
    (* 2^i *)
    sum := !sum + (value * power)
  done;
  let check = !sum mod 11 mod 10 in
  string_of_int check

let validate number =
  let number = compact number in

  (* Check length *)
  if String.length number <> 11 then raise Invalid_length;

  (* Check format: first 3 chars must be letters *)
  for i = 0 to 2 do
    let c = number.[i] in
    if not (c >= 'A' && c <= 'Z') then raise Invalid_format
  done;

  (* Check 4th character is U, J, Z, or R *)
  let fourth = number.[3] in
  if not (fourth = 'U' || fourth = 'J' || fourth = 'Z' || fourth = 'R') then
    raise Invalid_format;

  (* Check next 6 characters are digits *)
  for i = 4 to 9 do
    let c = number.[i] in
    if not (c >= '0' && c <= '9') then raise Invalid_format
  done;

  (* Check last character is a digit *)
  let last = number.[10] in
  if not (last >= '0' && last <= '9') then raise Invalid_format;

  (* Validate check digit *)
  let expected_check = calc_check_digit (String.sub number 0 10) in
  let actual_check = String.make 1 last in
  if expected_check <> actual_check then raise Invalid_checksum;

  number

let is_valid number =
  try
    ignore (validate number);
    true
  with Invalid_checksum | Invalid_length | Invalid_format -> false

let format number =
  let number = compact number in
  (* Format: XXXX XXXXXX X (4 chars, space, 6 chars, space, 1 char) *)
  let part1 = String.sub number 0 4 in
  let part2 = String.sub number 4 6 in
  let part3 = String.sub number 10 1 in
  part1 ^ " " ^ part2 ^ " " ^ part3
