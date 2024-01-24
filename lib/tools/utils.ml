let is_digits number =
  let is_digit c =
    Char.code c >= Char.code '0' && Char.code c <= Char.code '9'
  in
  String.for_all is_digit number

let clean number deletechars =
  Str.(global_replace (regexp deletechars) "" number)
