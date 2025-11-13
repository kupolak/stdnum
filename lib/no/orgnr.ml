(** Orgnr (Organisasjonsnummer, Norwegian organisation number).

    The Organisasjonsnummer is a 9-digit number with a straightforward check
    mechanism.

    More information:
    - https://nn.wikipedia.org/wiki/Organisasjonsnummer
    - https://no.wikipedia.org/wiki/Organisasjonsnummer *)

open Tools

exception Invalid_format
exception Invalid_length
exception Invalid_checksum

let compact number = Utils.clean number "[ ]" |> String.trim

let checksum number =
  let weights = [ 3; 2; 7; 6; 5; 4; 3; 2; 1 ] in
  let number_list =
    List.map (fun x -> int_of_char x - 48) (List.of_seq (String.to_seq number))
  in
  let sum =
    List.fold_left2 (fun acc w n -> acc + (w * n)) 0 weights number_list
  in
  sum mod 11

let validate number =
  let number = compact number in
  if not (Utils.is_digits number) then raise Invalid_format;
  if String.length number <> 9 then raise Invalid_length;
  if checksum number <> 0 then raise Invalid_checksum;
  number

let is_valid number =
  try
    ignore (validate number);
    true
  with Invalid_format | Invalid_length | Invalid_checksum -> false

let format number =
  let number = compact number in
  if String.length number <> 9 then number
  else
    String.sub number 0 3 ^ " " ^ String.sub number 3 3 ^ " "
    ^ String.sub number 6 3
