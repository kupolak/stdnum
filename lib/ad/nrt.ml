open Tools

exception Invalid_length
exception Invalid_format
exception Invalid_component

let compact number =
  let number =
    Utils.clean number " -." |> String.uppercase_ascii |> String.trim
  in
  if String.starts_with ~prefix:"AD" number then
    String.sub number 2 (String.length number - 2)
  else String.concat "" (String.split_on_char '-' number)

let isdigits s =
  try
    ignore (int_of_string s);
    true
  with Failure _ -> false

let is_alpha c =
  let ascii = Char.code c in
  (ascii >= Char.code 'a' && ascii <= Char.code 'z')
  || (ascii >= Char.code 'A' && ascii <= Char.code 'Z')

let validate number =
  let number = Utils.clean number "-." in
  if String.length number != 8 then raise Invalid_length;
  if (not (is_alpha number.[0])) || not (is_alpha number.[7]) then
    raise Invalid_format;
  if not (isdigits (String.sub number 1 6)) then raise Invalid_format;
  if
    not
      (List.mem number.[0] [ 'A'; 'C'; 'D'; 'E'; 'F'; 'G'; 'L'; 'O'; 'P'; 'U' ])
  then raise Invalid_component;
  if number.[0] = 'F' && String.sub number 1 6 > "699999" then
    raise Invalid_component;
  if
    List.mem number.[0] [ 'A'; 'L' ]
    && not ("699999" < String.sub number 1 6 && String.sub number 1 6 < "800000")
  then raise Invalid_component;
  number

let is_valid number =
  try
    ignore (validate number);
    true
  with _ -> false

let format number =
  let number = compact number in
  String.concat "-"
    [
      String.make 1 number.[0]; String.sub number 1 6; String.make 1 number.[7]
    ]
