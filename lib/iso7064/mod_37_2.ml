exception Invalid_checksum
exception Not_found

let alphabet = "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ*"

let index str char =
  let rec aux i =
    if i >= String.length str then raise Not_found
    else if str.[i] = char then i
    else aux (i + 1)
  in
  aux 0

let checksum ?(alphabet = alphabet) number =
  let modulus = String.length alphabet in
  let rec aux i check =
    if i >= String.length number then check
    else
      let n = index alphabet number.[i] in
      aux (i + 1) (((2 * check) + n) mod modulus)
  in
  aux 0 0

let calc_check_digit ?(alphabet = alphabet) number =
  let modulus = String.length alphabet in
  let index = (1 - (2 * checksum ~alphabet number) + modulus) mod modulus in
  alphabet.[index]

let validate ?(alphabet = alphabet) number =
  if checksum ~alphabet number = 1 then number else raise Invalid_checksum

let is_valid number =
  try
    ignore (validate number);
    true
  with Failure _ -> false
