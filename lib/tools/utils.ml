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
  if String.length deletechars = 0 || String.length number = 0 then number
  else
    let len = String.length deletechars in
    let chars_pattern =
      if len >= 2 && deletechars.[0] = '[' && deletechars.[len - 1] = ']' then
        String.sub deletechars 1 (len - 2)
      else deletechars
    in
    let mask = Array.make 256 false in
    let pat_len = String.length chars_pattern in
    let rec parse_chars i =
      if i >= pat_len then ()
      else
        let c = chars_pattern.[i] in
        if c = '\\' && i + 1 < pat_len then (
          let escaped = chars_pattern.[i + 1] in
          mask.(Char.code escaped) <- true;
          parse_chars (i + 2))
        else (
          mask.(Char.code c) <- true;
          parse_chars (i + 1))
    in
    parse_chars 0;
    let buf = Buffer.create (String.length number) in
    String.iter
      (fun c -> if not mask.(Char.code c) then Buffer.add_char buf c)
      number;
    Buffer.contents buf
