open Tools

exception Invalid_format
exception Invalid_length
exception Invalid_checksum

let compact number = Utils.clean number " " |> String.trim

let calc_check_digit number =
  let base_weights = [| 1; 2; 3; 4; 5; 6; 7 |] in
  let weights =
    match String.get number 0 with
    | '3' | '4' | '5' -> [| 7; 1; 2; 3; 4; 5; 6 |]
    | _ -> Array.copy base_weights
  in
  let sum_with weights =
    let total = ref 0 in
    for i = 0 to 6 do
      let digit = int_of_string (String.sub number i 1) in
      total := !total + (weights.(i) * digit)
    done;
    !total
  in
  let total = sum_with weights in
  let r = total mod 11 in
  if r < 10 then string_of_int r
  else
    (* Calculate again with other weights (+2) *)
    let weights' = Array.map (fun w -> w + 2) weights in
    let total' = sum_with weights' in
    string_of_int (total' mod 11 mod 10)

let validate number =
  let compact_number = compact number in

  if String.length compact_number <> 8 then raise Invalid_length;

  if not (Utils.is_digits compact_number) then raise Invalid_format;

  let check_digit = String.sub compact_number 7 1 in
  let calculated_check_digit = calc_check_digit compact_number in

  if check_digit <> calculated_check_digit then raise Invalid_checksum;

  compact_number

let is_valid number =
  try
    ignore (validate number);
    true
  with Invalid_format | Invalid_length | Invalid_checksum -> false

let format number = compact number
