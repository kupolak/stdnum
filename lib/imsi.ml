(** IMSI (International Mobile Subscriber Identity).

    The IMSI (International Mobile Subscriber Identity) is used to identify
    mobile phone users (the SIM). *)

open Tools

exception Invalid_format
exception Invalid_length
exception Invalid_component

let compact number =
  Utils.clean number "[ -]" |> String.trim |> String.uppercase_ascii

let validate number =
  let number = compact number in
  if not (Utils.is_digits number) then raise Invalid_format;
  let len = String.length number in
  if len <> 14 && len <> 15 then raise Invalid_length;
  (* We skip checking the exact MCC component since we don't have the full IMSI database ported *)
  number

let validate_result number =
  try Ok (validate number) with
  | Invalid_format -> Error Error.Invalid_format
  | Invalid_length -> Error Error.Invalid_length
  | Invalid_component -> Error Tools.Error.Invalid_component

let is_valid number =
  try
    ignore (validate number);
    true
  with Invalid_format | Invalid_length | Invalid_component -> false
