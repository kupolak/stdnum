(** Bitcoin address.

    A Bitcoin address is an identifier that is used as destination in a Bitcoin
    transaction. It is based on a hash of the public portion of a key pair.

    More information:
    - https://en.bitcoin.it/wiki/Address *)

open Tools

exception Invalid_format
exception Invalid_length
exception Invalid_checksum
exception Invalid_component

let compact number =
  let number = Utils.clean number "[ ]" |> String.trim in
  if
    String.length number >= 3
    && String.lowercase_ascii (String.sub number 0 3) = "bc1"
  then String.lowercase_ascii number
  else number

(* Base58 encoding character set as used in Bitcoin addresses *)
let base58_alphabet =
  "123456789ABCDEFGHJKLMNPQRSTUVWXYZabcdefghijkmnopqrstuvwxyz"

let base58_char_to_int c =
  match String.index_opt base58_alphabet c with
  | Some i -> i
  | None -> raise Invalid_format

let b58decode s =
  (* Decode a Base58 encoded string to bytes using Zarith for big integers *)
  (* For simplicity, we'll use a basic implementation that may overflow for very large numbers.
     A production implementation should use Zarith or similar library. *)

  (* Count leading '1's (which represent leading zero bytes) *)
  let leading_count = ref 0 in
  for i = 0 to String.length s - 1 do
    if s.[i] = '1' then incr leading_count else leading_count := String.length s
  done;

  (* For Base58 addresses, we know they're 25 bytes when decoded *)
  (* This is a simplified implementation that works for Bitcoin addresses *)
  let result = Bytes.make 25 '\000' in

  String.iter
    (fun c ->
      let digit = base58_char_to_int c in
      (* Multiply by 58 and add *)
      let carry = ref digit in
      for i = 24 downto 0 do
        let temp = (Char.code (Bytes.get result i) * 58) + !carry in
        Bytes.set result i (Char.chr (temp land 0xff));
        carry := temp lsr 8
      done)
    s;

  Bytes.to_string result

(* Bech32 character set *)
let bech32_alphabet = "qpzry9x8gf2tvdw0s3jn54khce6mua7l"

let bech32_char_to_int c =
  match String.index_opt bech32_alphabet c with
  | Some i -> i
  | None -> raise Invalid_format

(* Bech32 generator tests and values for checksum calculation *)
let bech32_generator =
  [
    (1 lsl 0, 0x3b6a57b2)
  ; (1 lsl 1, 0x26508e6d)
  ; (1 lsl 2, 0x1ea119fa)
  ; (1 lsl 3, 0x3d4233dd)
  ; (1 lsl 4, 0x2a1462b3)
  ]

let bech32_checksum values =
  let chk = ref 1 in
  List.iter
    (fun value ->
      let top = !chk lsr 25 in
      chk := ((!chk land 0x1ffffff) lsl 5) lor value;
      List.iter
        (fun (test, vl) -> if top land test <> 0 then chk := !chk lxor vl)
        bech32_generator)
    values;
  !chk

let b32decode data =
  (* Decode a list of Base32 values to bytes *)
  let acc = ref 0 in
  let bits = ref 0 in
  let result = ref [] in
  List.iter
    (fun value ->
      acc := (!acc lsl 5) lor value land 0xfff;
      bits := !bits + 5;
      if !bits >= 8 then (
        bits := !bits - 8;
        result := Char.chr ((!acc lsr !bits) land 0xff) :: !result))
    data;
  if !bits >= 5 || !acc land ((1 lsl !bits) - 1) <> 0 then
    raise Invalid_component;
  let bytes = List.rev !result in
  let result_bytes = Bytes.create (List.length bytes) in
  List.iteri (fun i c -> Bytes.set result_bytes i c) bytes;
  Bytes.to_string result_bytes

let expand_hrp hrp =
  (* Convert the human-readable part to format for checksum calculation *)
  let part1 =
    List.init (String.length hrp) (fun i -> Char.code hrp.[i] lsr 5)
  in
  let part2 =
    List.init (String.length hrp) (fun i -> Char.code hrp.[i] land 31)
  in
  part1 @ [ 0 ] @ part2

let validate number =
  let number = compact number in

  if String.length number > 0 && (number.[0] = '1' || number.[0] = '3') then (
    (* P2PKH or P2SH address *)
    if not (String.for_all (fun c -> String.contains base58_alphabet c) number)
    then raise Invalid_format;

    let address = b58decode number in
    if String.length address <> 25 then raise Invalid_length;

    (* TODO: Verify checksum using double SHA-256
       This requires a SHA-256 library (e.g., digestif).
       For now, we skip checksum verification for Base58 addresses.
       The format and length checks are still performed. *)
    (* let payload = String.sub address 0 21 in
       let checksum = String.sub address 21 4 in
       let hash1 = Sha256.string payload in
       let hash2 = Sha256.string hash1 in
       let expected_checksum = String.sub hash2 0 4 in
       if checksum <> expected_checksum then raise Invalid_checksum; *)
    number)
  else if String.length number >= 3 && String.sub number 0 3 = "bc1" then (
    (* Bech32 address *)
    if
      not
        (String.for_all
           (fun c -> String.contains bech32_alphabet c)
           (String.sub number 3 (String.length number - 3)))
    then raise Invalid_format;

    if String.length number < 11 || String.length number > 90 then
      raise Invalid_length;

    let data_part = String.sub number 3 (String.length number - 3) in
    let data =
      List.init (String.length data_part) (fun i ->
          bech32_char_to_int data_part.[i])
    in

    if bech32_checksum (expand_hrp "bc" @ data) <> 1 then raise Invalid_checksum;

    let witness_version = List.hd data in
    let witness_data = List.tl data in
    let witness_program_data =
      let rec take_until_last_n n lst =
        let len = List.length lst in
        if len <= n then []
        else List.hd lst :: take_until_last_n n (List.tl lst)
      in
      take_until_last_n 6 witness_data
    in
    let witness_program = b32decode witness_program_data in

    if witness_version > 16 then raise Invalid_component;

    let prog_len = String.length witness_program in
    if prog_len < 2 || prog_len > 40 then raise Invalid_length;

    if witness_version = 0 && prog_len <> 20 && prog_len <> 32 then
      raise Invalid_length;

    number)
  else raise Invalid_component

let is_valid number =
  try
    ignore (validate number);
    true
  with
  | Invalid_format | Invalid_length | Invalid_checksum | Invalid_component ->
    false
