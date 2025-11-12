open Tools

exception Invalid_length
exception Invalid_format
exception Invalid_checksum

let compact number =
  (* Use the same compact function as DNI *)
  Utils.clean number "[ -.]" |> String.trim |> String.uppercase_ascii

let luhn_calc_check_digit number =
  (* Luhn algorithm for calculating check digit *)
  let sum = ref 0 in
  let len = String.length number in
  for i = 0 to len - 1 do
    let digit = int_of_char number.[i] - int_of_char '0' in
    let pos_from_right = len - i in
    let value =
      if pos_from_right mod 2 = 1 then
        (* Double every other digit from the right (odd positions from right) *)
        let doubled = digit * 2 in
        if doubled > 9 then doubled - 9 else doubled
      else digit
    in
    sum := !sum + value
  done;
  string_of_int ((10 - (!sum mod 10)) mod 10)

let calc_check_digits number =
  (* Calculate the check digits for the specified number. The number
     passed should not have the check digit included. This function returns
     both the number and character check digit candidates. *)
  let check =
    luhn_calc_check_digit (String.sub number 1 (String.length number - 1))
  in
  let check_char = "JABCDEFGHI".[int_of_string check] in
  check ^ String.make 1 check_char

let validate number =
  let number = compact number in
  if String.length number <> 9 then raise Invalid_length;

  (* Check that middle digits are all numeric *)
  let middle = String.sub number 1 7 in
  if not (Utils.is_digits middle) then raise Invalid_format;

  (* First character must be one of the valid organisation types *)
  let first_char = number.[0] in
  if not (String.contains "ABCDEFGHJNPQRSUVW" first_char) then
    raise Invalid_format;

  (* Check digit validation *)
  let check_digits = calc_check_digits (String.sub number 0 8) in

  (* There seems to be conflicting information on which organisation types
     should have which type of check digit (alphabetic or numeric) so
     we support either here *)
  if not (String.contains check_digits number.[8]) then raise Invalid_checksum;

  number

let is_valid number =
  try
    ignore (validate number);
    true
  with Invalid_format | Invalid_length | Invalid_checksum -> false

let split number =
  let number = compact number in
  let type_letter = String.sub number 0 1 in
  let province = String.sub number 1 2 in
  let sequence = String.sub number 3 5 in
  let check_digit = String.sub number 8 1 in
  (type_letter, province, sequence, check_digit)
