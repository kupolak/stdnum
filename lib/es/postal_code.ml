open Tools

exception Invalid_length
exception Invalid_format
exception Invalid_component

let compact number = Utils.clean number " " |> String.trim

let validate number =
  let number = compact number in
  if String.length number <> 5 then raise Invalid_length;

  if not (Utils.is_digits number) then raise Invalid_format;

  (* Check if first two digits are between 01 and 52 *)
  let province = String.sub number 0 2 in
  let province_num = int_of_string province in
  if province_num < 1 || province_num > 52 then raise Invalid_component;

  number

let is_valid number =
  try
    ignore (validate number);
    true
  with Invalid_format | Invalid_length | Invalid_component -> false
