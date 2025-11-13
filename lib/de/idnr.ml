(** IdNr (Steuerliche Identifikationsnummer, German personal tax number).

    The IdNr (or Steuer-IdNr) is a personal identification number that is
    assigned to individuals in Germany for tax purposes and is meant to replace
    the Steuernummer. The number consists of 11 digits and does not embed any
    personal information.

    More information:
    - https://de.wikipedia.org/wiki/Steuerliche_Identifikationsnummer
    - http://www.identifikationsmerkmal.de/ *)

open Tools

exception Invalid_format
exception Invalid_length
exception Invalid_checksum

let compact number = Utils.clean number "[ .:/,\\-]" |> String.trim

let validate number =
  let number = compact number in
  if String.length number <> 11 then raise Invalid_length;
  if not (Utils.is_digits number) then raise Invalid_format;
  if number.[0] = '0' then raise Invalid_format;

  (* In the first 10 digits exactly one digit must be repeated two or
     three times and other digits can appear only once. *)
  let counter = Hashtbl.create 10 in
  for i = 0 to 9 do
    let digit = number.[i] in
    let count = try Hashtbl.find counter digit with Not_found -> 0 in
    Hashtbl.replace counter digit (count + 1)
  done;

  (* Count how many digits appear more than once *)
  let counts_greater_than_1 = ref [] in
  Hashtbl.iter
    (fun _ count ->
      if count > 1 then counts_greater_than_1 := count :: !counts_greater_than_1)
    counter;

  (* Exactly one digit must be repeated 2 or 3 times *)
  if List.length !counts_greater_than_1 <> 1 then raise Invalid_format;
  let repeated_count = List.hd !counts_greater_than_1 in
  if repeated_count <> 2 && repeated_count <> 3 then raise Invalid_format;

  (* Validate using ISO 7064 Mod 11-10 *)
  (try ignore (Iso7064.Mod_11_10.validate number)
   with Iso7064.Mod_11_10.Invalid_checksum -> raise Invalid_checksum);

  number

let is_valid number =
  try
    ignore (validate number);
    true
  with Invalid_format | Invalid_length | Invalid_checksum -> false

let format number =
  let num = compact number in
  String.concat " "
    [
      String.sub num 0 2
    ; String.sub num 2 3
    ; String.sub num 5 3
    ; String.sub num 8 3
    ]
