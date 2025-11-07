open Tools

exception Invalid_length
exception Invalid_format

let valid_control_keys =
  [
    'A'
  ; 'B'
  ; 'C'
  ; 'D'
  ; 'E'
  ; 'F'
  ; 'G'
  ; 'H'
  ; 'J'
  ; 'K'
  ; 'L'
  ; 'M'
  ; 'N'
  ; 'P'
  ; 'Q'
  ; 'R'
  ; 'S'
  ; 'T'
  ; 'V'
  ; 'W'
  ; 'X'
  ; 'Y'
  ; 'Z'
  ]

let valid_tva_codes = [ 'A'; 'P'; 'B'; 'D'; 'N' ]
let valid_category_codes = [ 'M'; 'P'; 'C'; 'N'; 'E' ]

let compact number =
  let cleaned =
    Utils.clean number "[ /.-]" |> String.trim |> String.uppercase_ascii
  in
  (* Zero pad the numeric serial to length 7 *)
  let serial_end = ref 0 in
  let i = ref 0 in
  while !i < String.length cleaned do
    if cleaned.[!i] >= '0' && cleaned.[!i] <= '9' then (
      serial_end := !i + 1;
      i := !i + 1)
    else if !serial_end = 0 then i := !i + 1
    else i := String.length cleaned (* break *)
  done;

  if !serial_end > 0 then
    let serial = String.sub cleaned 0 !serial_end in
    let rest =
      String.sub cleaned !serial_end (String.length cleaned - !serial_end)
    in
    let padded_serial = String.make (7 - String.length serial) '0' ^ serial in
    padded_serial ^ rest
  else cleaned

let validate number =
  let number = compact number in
  let len = String.length number in

  if len <> 8 && len <> 13 then raise Invalid_length;
  if not (Utils.is_digits (String.sub number 0 7)) then raise Invalid_format;
  if not (List.mem number.[7] valid_control_keys) then raise Invalid_format;

  if len = 8 then number
  else (
    if not (List.mem number.[8] valid_tva_codes) then raise Invalid_format;
    if not (List.mem number.[9] valid_category_codes) then raise Invalid_format;
    if not (Utils.is_digits (String.sub number 10 3)) then raise Invalid_format;
    let branch = String.sub number 10 3 in
    if branch <> "000" && number.[9] <> 'E' then raise Invalid_format;
    number)

let is_valid number =
  try
    ignore (validate number);
    true
  with Invalid_format | Invalid_length -> false

let format number =
  let result = compact number in
  let len = String.length result in
  if len = 8 then String.sub result 0 7 ^ "/" ^ String.make 1 result.[7]
  else
    String.sub result 0 7 ^ "/"
    ^ String.make 1 result.[7]
    ^ "/"
    ^ String.make 1 result.[8]
    ^ "/"
    ^ String.make 1 result.[9]
    ^ "/" ^ String.sub result 10 3
