(** Finnish Association Identifier.

    The number consists of 1 to 6 digits that are normally separated with a dot
    in groups of 0-3 and 0-3 numbers. E.g. 123.123, 12.123, 1.123, 123 or 1. *)

open Tools

exception Invalid_format
exception Invalid_length
exception Invalid_component

let low_numbers =
  [ 1; 6; 7; 9; 12; 14; 15; 16; 18; 22; 23; 24; 27; 28; 29; 35; 36; 38; 40;
    41; 42; 43; 45; 46; 50; 52; 55; 58; 60; 64; 65; 68; 72; 75; 76; 77; 78;
    83; 84; 85; 89; 92 ]

let compact number =
  Utils.clean number "[- ._+]" |> String.trim

let validate number =
  let number = compact number in
  if not (Utils.is_digits number) then raise Invalid_format;
  let len = String.length number in
  if len < 1 || len > 6 then raise Invalid_length;
  if len < 3 && not (List.mem (int_of_string number) low_numbers) then
    raise Invalid_component;
  number

let is_valid number =
  try
    ignore (validate number);
    true
  with Invalid_format | Invalid_length | Invalid_component -> false

let format number =
  let number = compact number in
  let len = String.length number in
  if len <= 3 then number
  else
    String.sub number 0 (len - 3) ^ "." ^ String.sub number (len - 3) 3
