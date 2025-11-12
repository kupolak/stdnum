open Tools

exception Invalid_length
exception Invalid_format
exception Invalid_checksum
exception Invalid_component

let compact number = Utils.clean number "[ /]" |> String.trim

let validate number =
  let number = compact number in
  if not (Utils.is_digits number) then raise Invalid_format;
  let len = String.length number in
  if len <> 9 && len <> 10 then raise Invalid_length;

  (* Extract date components *)
  let mm = int_of_string (String.sub number 2 2) in
  let dd = int_of_string (String.sub number 4 2) in

  (* Month can be increased by 50 for women, 20 for males, or 70 for women (post-2004) *)
  let month = mm mod 50 mod 20 in

  (* Basic validation of month and day *)
  if month < 1 || month > 12 then raise Invalid_component;
  if dd < 1 || dd > 31 then raise Invalid_component;

  (* For 10-digit numbers, validate the check digit using modulo 11 *)
  if len = 10 then begin
    let base_number = String.sub number 0 9 in
    let check_digit = int_of_char number.[9] - int_of_char '0' in
    let calculated = (int_of_string base_number) mod 11 in
    if calculated <> check_digit then raise Invalid_checksum
  end;

  number

let is_valid number =
  try
    ignore (validate number);
    true
  with Invalid_format | Invalid_length | Invalid_checksum | Invalid_component -> false
