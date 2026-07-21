(** n° d'accise (French number to identify taxpayers of excise taxes).

    The n° d'accise always start by FR0 following by the 2 ending digits of the
    year, 3 number of customs office, one letter for the type and an ordering
    number of 4 digits. *)

open Tools

exception Invalid_format
exception Invalid_length
exception Invalid_component

let operators = [ "E"; "N"; "C"; "B" ]

let compact number =
  Utils.clean number " " |> String.trim |> String.uppercase_ascii

let validate number =
  let number = compact number in
  let len = String.length number in
  if len < 3 then raise Invalid_length;

  let code = String.sub number 0 3 in
  if code <> "FR0" then raise Invalid_format;

  if len <> 13 then raise Invalid_length;

  if not (Utils.is_digits (String.sub number 3 2)) then raise Invalid_format;
  if not (Utils.is_digits (String.sub number 5 3)) then raise Invalid_format;

  let operator = String.sub number 8 1 in
  if not (List.mem operator operators) then raise Invalid_component;

  if not (Utils.is_digits (String.sub number 9 4)) then raise Invalid_format;

  number

let is_valid number =
  try
    ignore (validate number);
    true
  with Invalid_format | Invalid_length | Invalid_component -> false
