exception Invalid_format

let atin_re = Str.regexp "^9\\([0-9][0-9]\\)-93-\\([0-9][0-9][0-9][0-9]\\)$"

let validate number =
  if Str.string_match atin_re number 0 then number else raise Invalid_format

let is_valid number =
  try
    ignore (validate number);
    true
  with Invalid_format -> false

let format number =
  if String.length number = 9 then
    String.sub number 0 3 ^ "-" ^ String.sub number 3 2 ^ "-"
    ^ String.sub number 5 4
  else number
