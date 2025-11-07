open Tools

exception Invalid_length
exception Invalid_format
exception Invalid_component

(* Set of valid 2-digit or less COE numbers *)
let low_numbers =
  [
    2
  ; 4
  ; 6
  ; 7
  ; 8
  ; 9
  ; 10
  ; 11
  ; 13
  ; 16
  ; 18
  ; 19
  ; 20
  ; 21
  ; 25
  ; 26
  ; 30
  ; 32
  ; 33
  ; 35
  ; 36
  ; 37
  ; 38
  ; 39
  ; 40
  ; 42
  ; 45
  ; 47
  ; 49
  ; 51
  ; 52
  ; 55
  ; 56
  ; 57
  ; 58
  ; 59
  ; 61
  ; 62
  ; 64
  ; 65
  ; 66
  ; 67
  ; 68
  ; 69
  ; 70
  ; 71
  ; 72
  ; 73
  ; 74
  ; 75
  ; 76
  ; 79
  ; 80
  ; 81
  ; 84
  ; 85
  ; 87
  ; 88
  ; 91
  ; 92
  ; 94
  ; 95
  ; 96
  ; 97
  ; 99
  ]

let is_low_number n = List.mem n low_numbers

let compact number =
  let cleaned = Utils.clean number "[.]" |> String.trim in
  (* Strip leading zeros *)
  let rec strip_zeros s =
    if String.length s > 1 && s.[0] = '0' then
      strip_zeros (String.sub s 1 (String.length s - 1))
    else s
  in
  strip_zeros cleaned

let validate number =
  let number = compact number in
  let len = String.length number in
  if len = 0 || len > 5 then raise Invalid_length;
  if not (Utils.is_digits number) then raise Invalid_format;
  (if len < 3 then
     let num_val = int_of_string number in
     if not (is_low_number num_val) then raise Invalid_component);
  number

let is_valid number =
  try
    ignore (validate number);
    true
  with Invalid_format | Invalid_length | Invalid_component -> false
