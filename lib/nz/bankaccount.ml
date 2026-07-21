(** New Zealand bank account number

    The New Zealand bank account numbers consist of 16 digits. The first two
    represent the bank, followed by four for the branch, seven digits for the
    account base number and three for the account type.

    More information:
    - https://en.wikipedia.org/wiki/New_Zealand_bank_account_number *)

open Tools

exception Invalid_format
exception Invalid_length
exception Invalid_checksum
exception Invalid_component

let compact number =
  let parts =
    Utils.clean number " " |> String.trim |> String.split_on_char '-'
  in
  if List.length parts = 4 then
    let lengths = [ 2; 4; 7; 3 ] in
    let padded =
      List.map2
        (fun n l ->
          let len = String.length n in
          if len < l then String.make (l - len) '0' ^ n else n)
        parts lengths
    in
    String.concat "" padded
  else
    let number = String.concat "" parts in
    let len = String.length number in
    if len >= 13 then
      let prefix = String.sub number 0 13 in
      let suffix = String.sub number 13 (len - 13) in
      let suffix_len = String.length suffix in
      let padded_suffix =
        if suffix_len < 3 then String.make (3 - suffix_len) '0' ^ suffix
        else suffix
      in
      prefix ^ padded_suffix
    else number

let get_algorithm prefix =
  match prefix with
  | "01" | "02" | "03" | "04" | "06" | "10" | "11" | "12" | "13" | "14" | "15"
  | "16" | "17" | "18" | "19" | "20" | "21" | "22" | "23" | "24" | "27" | "30"
  | "35" | "38" ->
      "A"
  | "08" -> "D"
  | "09" -> "E"
  | "25" | "33" -> "F"
  | "26" | "28" | "29" -> "G"
  | "31" -> "X"
  | _ -> "X"

let get_weights algo =
  match algo with
  | "A" -> [| 0; 0; 6; 3; 7; 9; 0; 10; 5; 8; 4; 2; 1; 0; 0; 0 |]
  | "B" -> [| 0; 0; 0; 0; 0; 0; 0; 10; 5; 8; 4; 2; 1; 0; 0; 0 |]
  | "D" -> [| 0; 0; 0; 0; 0; 0; 7; 6; 5; 4; 3; 2; 1; 0; 0; 0 |]
  | "E" -> [| 0; 0; 0; 0; 0; 0; 0; 0; 0; 5; 4; 3; 2; 0; 0; 1 |]
  | "F" -> [| 0; 0; 0; 0; 0; 0; 1; 7; 3; 1; 7; 3; 1; 0; 0; 0 |]
  | "G" -> [| 0; 0; 0; 0; 0; 0; 1; 3; 7; 1; 3; 7; 1; 3; 7; 1 |]
  | "X" | _ -> [| 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0 |]

let get_moduli algo =
  match algo with
  | "A" | "B" | "D" -> (11, 11)
  | "E" -> (9, 11)
  | "F" -> (10, 10)
  | "G" -> (9, 10)
  | "X" | _ -> (1, 1)

let calc_checksum number =
  let prefix = String.sub number 0 2 in
  let algo = get_algorithm prefix in
  let algo =
    if algo = "A" && String.sub number 6 7 >= "0990000" then "B" else algo
  in
  let weights = get_weights algo in
  let mod1, mod2 = get_moduli algo in
  let check = ref 0 in
  for i = 0 to 15 do
    let w = weights.(i) in
    let n = int_of_char number.[i] - int_of_char '0' in
    let c = w * n in
    let c = if c > mod1 then c mod mod1 else c in
    check := !check + c
  done;
  !check mod mod2

let validate number =
  let number = compact number in
  if not (Utils.is_digits number) then raise Invalid_format;
  if String.length number <> 16 then raise Invalid_length;
  if calc_checksum number <> 0 then raise Invalid_checksum;
  (* In a full implementation, we'd check against banks.dat here to verify bank/branch *)
  let valid_banks =
    [
      "01"
    ; "02"
    ; "03"
    ; "04"
    ; "06"
    ; "08"
    ; "09"
    ; "10"
    ; "11"
    ; "12"
    ; "13"
    ; "14"
    ; "15"
    ; "16"
    ; "17"
    ; "18"
    ; "19"
    ; "20"
    ; "21"
    ; "22"
    ; "23"
    ; "24"
    ; "25"
    ; "26"
    ; "27"
    ; "28"
    ; "29"
    ; "30"
    ; "31"
    ; "33"
    ; "35"
    ; "38"
    ]
  in
  if not (List.mem (String.sub number 0 2) valid_banks) then
    raise Invalid_component;
  number

let is_valid number =
  try
    ignore (validate number);
    true
  with
  | Invalid_format | Invalid_length | Invalid_checksum | Invalid_component ->
    false

let format number =
  let number = compact number in
  String.sub number 0 2 ^ "-" ^ String.sub number 2 4 ^ "-"
  ^ String.sub number 6 7 ^ "-" ^ String.sub number 13 3
