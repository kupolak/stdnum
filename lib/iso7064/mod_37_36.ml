exception Invalid_format
exception Invalid_checksum
exception Not_found

let alphabet = "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ"

let index str char =
  let rec aux i =
    if i >= String.length str then raise Not_found
    else if str.[i] = char then i
    else aux (i + 1)
  in
  aux 0

let checksum ?(alphabet = alphabet) number =
  let modulus = String.length alphabet in
  let check = ref (modulus / 2) in
  try
    for i = 0 to String.length number - 1 do
      let n = index alphabet number.[i] in
      let c = if !check = 0 then modulus else !check in
      check := ((c * 2 mod (modulus + 1)) + n) mod modulus
    done;
    !check
  with Not_found -> raise Invalid_format

let calc_check_digit ?(alphabet = alphabet) number =
  let modulus = String.length alphabet in
  let c = checksum ~alphabet number in
  let c' = if c = 0 then modulus else c in
  let intermediate = 1 - (c' * 2 mod (modulus + 1)) in
  (* Handle negative modulo *)
  let idx = ((intermediate mod modulus) + modulus) mod modulus in
  alphabet.[idx]

let validate ?(alphabet = alphabet) number =
  let is_valid = try checksum ~alphabet number = 1 with _ -> false in
  if not is_valid then raise Invalid_checksum;
  number

let is_valid ?(alphabet = alphabet) number =
  try
    ignore (validate ~alphabet number);
    true
  with Invalid_format | Invalid_checksum -> false
