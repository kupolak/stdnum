(** RČ (Rodné číslo, the Slovak birth number).

    The birth number (RČ, Rodné číslo) is the Slovak national identifier. The
    number can be 9 or 10 digits long. Numbers given out after January 1st 1954
    should have 10 digits. The number includes the birth date of the person and
    their gender.

    This number is identical to the Czech counterpart. *)

exception Invalid_format
exception Invalid_length
exception Invalid_checksum
exception Invalid_component

let compact number = Cz.Rc.compact number

let validate number =
  try Cz.Rc.validate number with
  | Cz.Rc.Invalid_format -> raise Invalid_format
  | Cz.Rc.Invalid_length -> raise Invalid_length
  | Cz.Rc.Invalid_checksum -> raise Invalid_checksum
  | Cz.Rc.Invalid_component -> raise Invalid_component

let is_valid number =
  try
    ignore (validate number);
    true
  with
  | Invalid_format | Invalid_length | Invalid_checksum | Invalid_component ->
    false

let format number = Cz.Rc.format number
