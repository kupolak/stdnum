(** Onderwijsnummer (the Dutch student identification number).

    The onderwijsnummers (education number) is very similar to the BSN (Dutch
    citizen identification number), but is for students without a BSN. It uses a
    checksum mechanism similar to the BSN.

    More information:
    - https://nl.wikipedia.org/wiki/Onderwijsnummer *)

open Tools

exception Invalid_format
exception Invalid_length
exception Invalid_checksum

(* Re-use BSN's compact and checksum functions *)
let compact = Bsn.compact
let checksum = Bsn.checksum

let validate number =
  let number = compact number in
  if (not (Utils.is_digits number)) || int_of_string number <= 0 then
    raise Invalid_format;
  (* Must start with "10" *)
  if String.length number >= 2 && String.sub number 0 2 <> "10" then
    raise Invalid_format;
  if String.length number <> 9 then raise Invalid_length;
  (* Checksum must equal 5 (not 0 like BSN) *)
  if checksum number <> 5 then raise Invalid_checksum;
  number

let is_valid number =
  try
    ignore (validate number);
    true
  with Invalid_format | Invalid_length | Invalid_checksum -> false
