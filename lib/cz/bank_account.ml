open Tools

exception Invalid_length
exception Invalid_format
exception Invalid_checksum
exception Invalid_bank

let compact number =
  let cleaned = Utils.clean number " " |> String.trim in
  (* Parse the format: [prefix-]root/bank *)
  try
    let slash_pos = String.index cleaned '/' in
    let account_part = String.sub cleaned 0 slash_pos in
    let bank_code =
      String.sub cleaned (slash_pos + 1) (String.length cleaned - slash_pos - 1)
    in

    (* Find dash position or use empty prefix *)
    let prefix, root =
      try
        let dash_pos = String.index account_part '-' in
        let p = String.sub account_part 0 dash_pos in
        let r =
          String.sub account_part (dash_pos + 1)
            (String.length account_part - dash_pos - 1)
        in
        (p, r)
      with Not_found -> ("", account_part)
    in

    (* Zero-pad prefix to 6 digits and root to 10 digits *)
    let padded_prefix = String.make (6 - String.length prefix) '0' ^ prefix in
    let padded_root = String.make (10 - String.length root) '0' ^ root in

    padded_prefix ^ "-" ^ padded_root ^ "/" ^ bank_code
  with Not_found | Invalid_argument _ ->
    (* If parsing fails, return as-is for validation to catch *)
    cleaned

let calc_checksum number =
  let weights = [| 6; 3; 7; 9; 10; 5; 8; 4; 2; 1 |] in
  let len = String.length number in
  if len > 10 then raise Invalid_length;

  let padded = String.make (10 - len) '0' ^ number in
  let sum = ref 0 in
  for i = 0 to 9 do
    let digit = int_of_char padded.[i] - int_of_char '0' in
    sum := !sum + (weights.(i) * digit)
  done;
  !sum mod 11

let validate number =
  let cleaned = compact number in

  (* Parse the format: prefix-root/bank *)
  let parts = String.split_on_char '/' cleaned in
  if List.length parts <> 2 then raise Invalid_format;

  let account_part = List.nth parts 0 in
  let bank_code = List.nth parts 1 in

  (* Check bank code is 4 digits *)
  if String.length bank_code <> 4 then raise Invalid_format;
  if not (String.for_all (fun c -> c >= '0' && c <= '9') bank_code) then
    raise Invalid_format;

  (* Parse prefix and root *)
  let account_parts = String.split_on_char '-' account_part in
  if List.length account_parts <> 2 then raise Invalid_format;

  let prefix = List.nth account_parts 0 in
  let root = List.nth account_parts 1 in

  (* Check lengths *)
  if String.length prefix <> 6 then raise Invalid_length;
  if String.length root <> 10 then raise Invalid_length;

  (* Check all digits *)
  if not (String.for_all (fun c -> c >= '0' && c <= '9') prefix) then
    raise Invalid_format;
  if not (String.for_all (fun c -> c >= '0' && c <= '9') root) then
    raise Invalid_format;

  (* Validate checksums *)
  if calc_checksum prefix <> 0 then raise Invalid_checksum;
  if calc_checksum root <> 0 then raise Invalid_checksum;

  (* Validate bank code (basic check - not 0000) *)
  if bank_code = "0000" then raise Invalid_bank;

  cleaned

let is_valid number =
  try
    let _ = validate number in
    true
  with Invalid_format | Invalid_length | Invalid_checksum | Invalid_bank ->
    false

let format number = compact number
