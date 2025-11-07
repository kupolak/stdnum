open Tools

exception Invalid_format

let compact number = Utils.clean number "[ -]" |> String.trim

let tin_type number =
  let number = compact number in
  if Moa.is_valid number then Some "moa"
  else if Pin.is_valid number then Some "pin"
  else None

let validate number =
  if Moa.is_valid number then Moa.validate number
  else if Pin.is_valid number then Pin.validate number
  else raise Invalid_format

let is_valid number =
  try
    ignore (validate number);
    true
  with Invalid_format -> false

let format number =
  if Moa.is_valid number then Moa.format number
  else if Pin.is_valid number then Pin.format number
  else number
