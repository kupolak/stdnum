open Tools

exception Invalid_format
exception Invalid_length
exception Invalid_checksum

(** Convert the number to the minimal representation.
    
    This strips the number of any valid separators and removes surrounding
    whitespace. *)
let compact number =
  let number = String.trim number in
  let clean_char c = match c with ' ' | '.' | '-' -> true | _ -> false in
  let buffer = Buffer.create (String.length number) in
  String.iter (fun c -> if not (clean_char c) then Buffer.add_char buffer c) number;
  Buffer.contents buffer

(** Calculate the check digits for the number. *)
let calc_check_digits number =
  (* First check digit *)
  let d1 = ref 0 in
  for i = 0 to 8 do
    d1 := !d1 + (10 - i) * (int_of_char number.[i] - int_of_char '0')
  done;
  let d1 = (11 - (!d1 mod 11)) mod 11 mod 10 in
  
  (* Second check digit *)
  let d2 = ref 0 in
  for i = 0 to 8 do
    d2 := !d2 + (11 - i) * (int_of_char number.[i] - int_of_char '0')
  done;
  d2 := !d2 + 2 * d1;
  let d2 = (11 - (!d2 mod 11)) mod 11 mod 10 in
  
  Printf.sprintf "%d%d" d1 d2

(** Check if the number is a valid CPF.
    
    This checks the length and whether the check digit is correct. *)
let validate number =
  let number = compact number in
  
  (* Check if it contains only digits *)
  if not (Utils.is_digits number) then raise Invalid_format;
  
  (* Check if the number is greater than 0 *)
  (try
     if int_of_string number <= 0 then raise Invalid_format
   with Failure _ -> raise Invalid_format);
  
  (* Check length *)
  if String.length number <> 11 then raise Invalid_length;
  
  (* Check checksum *)
  let expected_check = calc_check_digits number in
  let actual_check = String.sub number 9 2 in
  if expected_check <> actual_check then raise Invalid_checksum;
  
  number

(** Check if the number is a valid CPF. *)
let is_valid number =
  try
    let _ = validate number in
    true
  with Invalid_format | Invalid_length | Invalid_checksum -> false

(** Reformat the number to the standard presentation format. *)
let format number =
  let number = compact number in
  Printf.sprintf "%s.%s.%s-%s"
    (String.sub number 0 3)
    (String.sub number 3 3)
    (String.sub number 6 3)
    (String.sub number 9 2)
