let is_digits number =
  let is_digit c =
    Char.code c >= Char.code '0' && Char.code c <= Char.code '9'
  in
  String.for_all is_digit number

let is_alpha s =
  let is_alpha_char c =
    (Char.code c >= Char.code 'A' && Char.code c <= Char.code 'Z')
    || (Char.code c >= Char.code 'a' && Char.code c <= Char.code 'z')
  in
  String.for_all is_alpha_char s

let is_alnum s =
  let is_alnum_char c =
    (Char.code c >= Char.code '0' && Char.code c <= Char.code '9')
    || (Char.code c >= Char.code 'A' && Char.code c <= Char.code 'Z')
    || (Char.code c >= Char.code 'a' && Char.code c <= Char.code 'z')
  in
  String.for_all is_alnum_char s

let clean number deletechars =
  Str.(global_replace (regexp deletechars) "" number)
