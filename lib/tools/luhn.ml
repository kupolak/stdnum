exception Invalid_format
exception Invalid_checksum

let checksum ?(alphabet = "0123456789") number =
  let n = String.length alphabet in
  let num_len = String.length number in

  (* Helper to find index of character in alphabet *)
  let index_of c =
    let rec find i =
      if i >= n then raise Not_found
      else if alphabet.[i] = c then i
      else find (i + 1)
    in
    find 0
  in

  (* Calculate checksum *)
  let total = ref 0 in
  for i = 0 to num_len - 1 do
    let pos = num_len - 1 - i in
    (* reverse iteration *)
    let value = index_of number.[pos] in
    if i mod 2 = 0 then
      (* Even positions (from right): add directly *)
      total := !total + value
    else
      (* Odd positions (from right): double and add digits *)
      let doubled = value * 2 in
      let digit_sum = (doubled / n) + (doubled mod n) in
      total := !total + digit_sum
  done;
  !total mod n

let validate ?(alphabet = "0123456789") number =
  if String.length number = 0 then raise Invalid_format;
  let is_valid = try checksum ~alphabet number = 0 with _ -> false in
  if not is_valid then raise Invalid_checksum;
  number

let is_valid ?(alphabet = "0123456789") number =
  try
    ignore (validate ~alphabet number);
    true
  with Invalid_format | Invalid_checksum -> false

let calc_check_digit ?(alphabet = "0123456789") number =
  let ck = checksum ~alphabet (number ^ String.make 1 alphabet.[0]) in
  let n = String.length alphabet in
  String.make 1 alphabet.[n - ck]
