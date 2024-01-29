open Tools

exception Invalid_length
exception Invalid_format

let nipt_re = Str.regexp "^[A-M][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][A-Z]$"

let compact number =
  let number =
    Utils.clean number " " |> String.uppercase_ascii |> String.trim
  in
  if String.starts_with number ~prefix:"AL" then
    String.sub number 2 (String.length number - 2)
  else if String.starts_with number ~prefix:"(AL)" then
    String.sub number 4 (String.length number - 4)
  else number

let validate number =
  let number = compact number in
  print_string number;
  if not (Str.string_match nipt_re number 0) then raise Invalid_format
  else number

let is_valid number =
  try
    ignore (validate number);
    true
  with _ -> false
